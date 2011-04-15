Unroll::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end




# require 'active_support/whiny_nil'
# 
# 
# Dependencies.mechanism                             = :load
# ActionController::Base.consider_all_requests_local = true
# ActionController::Base.perform_caching             = false
# BREAKPOINT_SERVER_PORT = 42531
# config.log_level = :debug
# 
# # for now to kill mail attempts
# ActionMailer::Base.delivery_method                 = :test
