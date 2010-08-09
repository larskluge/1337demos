# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  config.gem 'rack'
  config.gem 'gravtastic', :version => '>= 2.1.0'
  config.gem 'haml', :version => '>= 3'
  config.gem 'demo-reader', :version => '>= 0.1.2'
  config.gem 'will_paginate'

  SYS_MAP_IMAGES = RAILS_ROOT + '/data/maps/images/'
  SYS_MAP_IMAGE_THUMBS = RAILS_ROOT + '/public/images/maps/thumbs/'
  SYS_VIDEOS = RAILS_ROOT + '/public/videos/'

  WEB_DEFAULT_HOST = '1337demos.com'
  WEB_MAP_IMAGE_THUMBS = '/images/maps/thumbs/'
  WEB_VIDEOS = '/videos/'

  # configure action mailer
  config.action_mailer.delivery_method = :sendmail

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths << Rails.root + "app/controllers/lib"


  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '1337demos_session',
    :secret      => '201c9ca2d8956eb62c8a1e91ce124ed28a9cf1571e900a112c2f2d11ebd2acf5ff4ad81deceee166d4564fae762201eb3e48346164497d232ad444d8dda734b9'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end

  # See Rails::Configuration for more options

  $KCODE = 'u'
end

# configure exception-notification
ExceptionNotifier.exception_recipients = %w(1337demos@freshthinking.de)
ExceptionNotifier.sender_address = %("1337demos exception notifier" <exception-notifier@1337demos.com>)

