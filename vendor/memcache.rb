require 'socket'
require 'timeout'

# A Ruby client library for memcached.
#
# This is intended to provide access to basic memcached functionality.  It
# does not attempt to be complete implementation of the entire API.
#
# In particular, the methods of this class are not thread safe.  The calling
# application is responsible for implementing any necessary locking if a cache
# object will be called from multiple threads.
class MemCache
    # The total amount of time to wait for a request to complete.
    REQUEST_TIMEOUT = 0.5

    # Patterns for matching against server error replies.
    GENERAL_ERROR = /^ERROR\r\n/
    CLIENT_ERROR  = /^CLIENT_ERROR/
    SERVER_ERROR  = /^SERVER_ERROR/

    # Default options for the cache object.
    DEFAULT_OPTIONS = {
        :namespace => nil,
        :readonly  => false
    }

    # Default memcached port.
    DEFAULT_PORT = 11211

    # Default memcached server weight.
    DEFAULT_WEIGHT = 1

    # The amount of time to wait for a response from a memcached server.  If a
    # response is not completed within this time, the connection to the server
    # will be closed and an error will be raised.
    attr_accessor :request_timeout
   
    # Valid options are:
    #
    #     :namespace
    #         If specified, all keys will have the given value prepended
    #         before accessing the cache.  Defaults to nil.
    #
    #     :readonly
    #         If this is set, any attempt to write to the cache will generate
    #         an exception.  Defaults to false.
    # 
    def initialize(opts = {})
        opts = DEFAULT_OPTIONS.merge(opts)   
        @namespace = opts[:namespace]
        @readonly  = opts[:readonly]

        @servers = []
        @buckets = []
    end

    # Return a string representation of the cache object.
    def inspect
        sprintf("<MemCache: %s servers, %s buckets, ns: %p, ro: %p>",
                @servers.nitems, @buckets.nitems, @namespace, @readonly)
    end

    # Returns whether there is at least one active server for the object.
    def active?
        not @servers.empty?
    end
    
    # Returns whether the cache was created read only.
    def readonly?
        @readonly
    end

    # Set the servers that the requests will be distributed between.  Entries
    # can be either strings of the form "hostname:port" or
    # "hostname:port:weight" or MemCache::Server objects.
    def servers=(servers)
        # Create the server objects.
        @servers = servers.collect do |server|
            case server
            when String
                host, port, weight = server.split(/:/, 3)
                port ||= DEFAULT_PORT
                weight ||= DEFAULT_WEIGHT
                Server::new(host, port, weight)
            when Server
                server
            else
                raise TypeError, "Cannot convert %s to MemCache::Server" %
                    svr.class.name
            end
        end

        # Create an array of server buckets for weight selection of servers.
        @buckets = []
        @servers.each do |server|
            server.weight.times { @buckets.push(server) }
        end
    end

    def get(key)
        raise MemCacheError, "No active servers" unless self.active?
        cache_key = make_cache_key(key)
        server = get_server_for_key(cache_key)

        sock = server.socket
        if sock.nil?
            raise MemCacheError, "No connection to server"
        end

        value = nil
        begin
            timeout(REQUEST_TIMEOUT) do
                sock.write "get #{cache_key}\r\n"
                text = sock.gets # "VALUE <key> <flags> <bytes>\r\n"
                return nil if text =~ /^END/ # HACK: no regex

                v, cache_key, flags, bytes = text.split(/ /)
                value = sock.read(bytes.to_i)
                sock.read(2) # "\r\n"
                sock.gets    # "END\r\n"
            end
        rescue SystemCallError, IOError, Timeout::Error => err
            server.close
            raise MemCacheError, err.message
        end

        # Return the unmarshaled value.
        Marshal.load(value)
    end

    # Add an entry to the cache.
    def set(key, value, expiry = 0)
        raise MemCacheError, "No active servers" unless self.active?
        raise MemCacheError, "Update of readonly cache" if @readonly
        cache_key = make_cache_key(key)
        server = get_server_for_key(cache_key)

        sock = server.socket
        if sock.nil?
            raise MemCacheError, "No connection to server"
        end

        marshaled_value = Marshal.dump(value)
        command = "set #{cache_key} 0 #{expiry} #{marshaled_value.size}\r\n" +
                  marshaled_value + "\r\n"

        begin
            timeout(REQUEST_TIMEOUT) do
                sock.write command
                sock.gets
            end
        rescue SystemCallError, IOError, Timeout::Error => err
            server.close
            raise MemCacheError, err.message
        end
    end

    # Remove an entry from the cache.
    def delete(key, expiry = 0)
        raise MemCacheError, "No active servers" unless self.active?
        cache_key = make_cache_key(key)
        server = get_server_for_key(cache_key)

        sock = server.socket
        if sock.nil?
            raise MemCacheError, "No connection to server"
        end

        begin
            timeout(REQUEST_TIMEOUT) do
                sock.write "delete #{cache_key} #{expiry}\r\n"
                sock.gets
            end
        rescue SystemCallError, IOError, Timeout::Error => err
            server.close
            raise MemCacheError, err.message
        end
    end

    # Shortcut to get a value from the cache.
    def [](key)
        self.get(key)
    end

    # Shortcut to save a value in the cache.  This method does not set an
    # expiration on the entry.  Use set to specify an explicit expiry.
    def []=(key, value)
        self.set(key, value)
    end

    # Create a key for the cache, incorporating the namespace qualifier if
    # requested.
    protected
    def make_cache_key(key)
        @namespace.nil? ? key.to_s : "#{@namespace}:#{key}"
    end

    # Pick a server to handle the request based on a hash of the key.
    def get_server_for_key(key)
        # Easy enough if there is only one server.
        return @servers.first if @servers.length == 1

        # Hash the value of the key to select the bucket.
        hkey = key.hash
        
        # Fetch a server for the given key, retrying if that server is
        # offline.
        server = nil
        20.times do |tries|
            server = @buckets[(hkey + tries) % @buckets.nitems]
            break if server.alive?
        end

        raise MemCacheError, "No servers available" unless server
        server
    end

    
    ###########################################################################
    # S E R V E R   C L A S S
    ###########################################################################

    # This class represents a memcached server instance.
    class Server
        # The amount of time to wait to establish a connection with a
        # memcached server.  If a connection cannot be established within
        # this time limit, the server will be marked as down.
        CONNECT_TIMEOUT = 0.25

        # The amount of time to wait before attempting to re-establish a
        # connection with a server that is marked dead.
        RETRY_DELAY = 30.0

        # The host the memcached server is running on.
        attr_reader :host

        # The port the memcached server is listening on.
        attr_reader :port

        # The weight given to the server.
        attr_reader :weight

        # The time of next retry if the connection is dead.
        attr_reader :retry

        # A text status string describing the state of the server.
        attr_reader :status
        
        # Create a new MemCache::Server object for the memcached instance
        # listening on the given host and port, weighted by the given weight.
        def initialize(host, port = DEFAULT_PORT, weight = DEFAULT_WEIGHT)
            if host.nil? || host.empty?
                raise ArgumentError, "No host specified"
            elsif port.nil? || port.to_i.zero?
                raise ArgumentError, "No port specified"
            end

            @host   = host
            @port   = port.to_i
            @weight = weight.to_i

            @sock   = nil
            @retry  = nil
            @status = "NOT CONNECTED"
        end

        # Return a string representation of the server object.
        def inspect
            sprintf("<MemCache::Server: %s:%d [%d] (%s)>",
                    @host, @port, @weight, @status)
        end

        # Check whether the server connection is alive.  This will cause the
        # socket to attempt to connect if it isn't already connected and or if
        # the server was previously marked as down and the retry time has
        # been exceeded.
        def alive?
            !self.socket.nil?
        end

        # Try to connect to the memcached server targeted by this object.
        # Returns the connected socket object on success or nil on failure.
        def socket
            # Attempt to connect if not already connected.
            unless @sock || (!@sock.nil? && @sock.closed?)
                # If the host was dead, don't retry for a while.
                if @retry && (@retry > Time::now)
                    @sock = nil
                else
                    begin
                        @sock = timeout(CONNECT_TIMEOUT) {
                            TCPSocket::new(@host, @port)
                        }
                        @retry  = nil
                        @status = "CONNECTED"
                    rescue SystemCallError, IOError, Timeout::Error => err
                        self.mark_dead(err.message)
                    end
                end
            end
            @sock
        end

        # Close the connection to the memcached server targeted by this
        # object.  The server is not considered dead.
        def close
            @sock.close if @sock &&!@sock.closed?
            @sock   = nil
            @retry  = nil
            @status = "NOT CONNECTED"
        end

        # Mark the server as dead and close its socket.
        def mark_dead(reason = "Unknown error")
            @sock.close if @sock && !@sock.closed?
            @sock   = nil
            @retry  = Time::now + RETRY_DELAY
            
            @status = sprintf("DEAD: %s, will retry at %s", reason, @retry)
        end
    end
    
    
    ###########################################################################
    # E X C E P T I O N   C L A S S E S
    ###########################################################################

    # Base MemCache exception class.
    class MemCacheError < ::Exception
    end

    # MemCache internal error class.  Instances of this class mean that there
    # is some internal error either in the memcache client library or the
    # memcached server it is talking to.
    class InternalError < MemCacheError
    end

    # MemCache client error class.  Instances of this class mean that a
    # "CLIENT_ERROR" response was seen in the dialog with a memcached server.
    class ClientError < InternalError
    end

    # MemCache server error class.  Instances of this class mean that a
    # "SERVER_ERROR" response was seen in the dialog with a memcached server.
    class ServerError < InternalError
        attr_reader :server
        
        def initalize(server)
            @server = server
        end
    end
end
