RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
RAILS_ENV  = ENV['RAILS_ENV'] || 'development'


# Mocks first.
ADDITIONAL_LOAD_PATHS = ["#{RAILS_ROOT}/test/mocks/#{RAILS_ENV}"]

# Then model subdirectories.
ADDITIONAL_LOAD_PATHS.concat(Dir["#{RAILS_ROOT}/app/models/[_a-z]*"])

# Followed by the standard includes.
ADDITIONAL_LOAD_PATHS.concat %w(
  app
  app/models
  app/controllers
  app/helpers
  config
  lib
  vendor
  vendor/railties
  vendor/railties/lib
  vendor/activerecord/lib
  vendor/actionpack/lib
  vendor/actionmailer/lib
).map { |dir| "#{RAILS_ROOT}/#{dir}" }

# Prepend to $LOAD_PATH
ADDITIONAL_LOAD_PATHS.reverse.each { |dir| $:.unshift(dir) if File.directory?(dir) }


# Require Rails libraries.
require 'active_record'
require 'action_controller'
require 'action_mailer'


# Environment-specific configuration.
ActionController::Base.require_or_load "environments/#{RAILS_ENV}"
ActiveRecord::Base.configurations = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml"))
ActiveRecord::Base.establish_connection


# Configure defaults if the included environment did not.
RAILS_DEFAULT_LOGGER = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
[ActiveRecord::Base, ActionController::Base, ActionMailer::Base].each do |klass|
  klass.logger ||= RAILS_DEFAULT_LOGGER
end
[ActionController::Base, ActionMailer::Base].each do |klass|
  klass.template_root ||= "#{RAILS_ROOT}/app/views/"
end


# Include your app's configuration here:
