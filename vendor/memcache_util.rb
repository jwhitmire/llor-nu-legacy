##
# A utility wrapper around the MemCache client to simplify cache access.  All
# methods silently ignore MemCache errors.

module Cache

    ##
    # Returns the object at +key+ from the cache if successful, or nil if
    # either the object is not in the cache or if there was an error
    # attermpting to access the cache.
    #--
    # FIXME get rid of ensure

    def self.get(key)
        start_time = Time.now.to_f
        result = CACHE.get key
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.warn(
            sprintf("MemCache Get (%0.6f)  %s",
                    end_time - start_time, key))
    rescue MemCache::MemCacheError # MemCache error is a cache miss.
        result = nil
    ensure
        return result
    end

    ##
    # Places +value+ in the cache at +key+, with an optional +expiry+ time in
    # seconds. (?)

    def self.put(key, value, expiry = 0)
        start_time = Time.now.to_f
        CACHE.set key, value, expiry
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.warn(
            sprintf("MemCache Set (%0.6f)  %s",
                    end_time - start_time, key))
    rescue MemCache::MemCacheError
    end

    ##
    # Deletes +key+ from the cache in +delay+ seconds. (?)

    def self.delete(key, delay = nil)
        start_time = Time.now.to_f
        CACHE.delete key, delay
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.warn(
            sprintf("MemCache Delete (%0.6f)  %s",
                    end_time - start_time, key))
    rescue MemCache::MemCacheError
    end

end

# vim: ts=4 sts=4 sw=4

