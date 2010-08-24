# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# silence the gem spec warnings
Rails::VendorGemSourceIndex.silence_spec_warnings = true

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Berlin'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # setup constants
  SYS_MAP_IMAGES = RAILS_ROOT + '/data/maps/images/'
  SYS_MAP_IMAGE_THUMBS = RAILS_ROOT + '/public/images/maps/thumbs/'
  SYS_VIDEOS = RAILS_ROOT + '/public/videos/'

  WEB_DEFAULT_HOST = '1337demos.com'
  WEB_MAP_IMAGE_THUMBS = '/images/maps/thumbs/'
  WEB_VIDEOS = '/videos/'

  # configure action mailer
  config.action_mailer.delivery_method = :sendmail

  $KCODE = 'u'
end

# configure exception-notification
ExceptionNotifier.exception_recipients = %w(1337demos@freshthinking.de)
ExceptionNotifier.sender_address = %("1337demos exception notifier" <exception-notifier@1337demos.com>)

Haml::Template.options[:format] = :html5

