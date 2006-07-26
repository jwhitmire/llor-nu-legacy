require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Automagically find the environment from the current path
  def get_environment
    fullpath = File.expand_path(__FILE__,RAILS_ROOT)
    return case fullpath
      when /\/staging\//: 'production'
      when /\/production\//: 'production'
      else 'development'
    end
  end

  RAILS_ENV = (ENV['RAILS_ENV'] || get_environment) unless defined?RAILS_ENV

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services #{RAILS_ROOT}/app/services )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  #config.log_level = :debug

  # Remember to rake create_sessions_table if you're using the active_record_store.
  config.action_controller.session_store = :active_record_store

  # Remember to create this directory, too, if you're using file_Store.
  config.action_controller.fragment_cache_store = :file_store, RAILS_ROOT + "/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  #config.active_record.default_timezone = :utc
  
  # enable this line to prevent session restore errors during development
  #config.action_controller.session_options( :prefix => 'llor.', :session_key => 'llor' )

end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Load the variables from the salted-login user system.
# You should change these to match your environment/server.
require 'environments/user_environment'

# initial game constants
  STARTING_BALANCE = 5000
  STARTING_ITEM_ID = 1
  STARTING_ITEM_USES = 3
  STARTING_ITEM_ACTIVE = 1
  QUICKY_PERCENTAGE = 0.3
  BUYABLES_PERCENTAGE = 1.5
  FREE_SQUARES_PERCENTAGE = 0.3
  SQUARE_DOLER_ALLOTMENTS = {1 => 1, 3 => 1, 5 => 1}
  SEED = 33082828

# Prevent session-restore errors from clashing cookie names (see above also)
#ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS[:prefix] = "light_llor_sess"

# You'll need to install random/mt19937 from http://raa.ruby-lang.org/project/random-mt19937/
# for some of the random-number generation magic.
require 'random/mt19937'