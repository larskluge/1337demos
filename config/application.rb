require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module LeetdemosPlatform
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{Rails.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # setup constants
    ::SYS_MAP_IMAGES = "#{Rails.root}/data/maps/images/"
    ::SYS_MAP_IMAGE_THUMBS = "#{Rails.root}/public/images/maps/thumbs/"
    ::SYS_VIDEOS = "#{Rails.root}/public/videos/"

    ::WEB_DEFAULT_HOST = '1337demos.com'
    ::WEB_MAP_IMAGE_THUMBS = '/images/maps/thumbs/'
    ::WEB_VIDEOS = '/videos/'

    # configure action mailer
    config.action_mailer.delivery_method = :sendmail

    # exception_notifier
    #
    config.middleware.use ExceptionNotifier,
      :sender_address => %("1337demos exception notifier" <exception-notifier@1337demos.com>),
      :exception_recipients => %w(1337demos@freshthinking.de),
      :ignore_exceptions => [
        AbstractController::ActionNotFound,
        ActionController::InvalidAuthenticityToken
        ActionController::RoutingError,
        ActiveRecord::RecordNotFound,
      ]

    # use jquery by default
    config.action_view.javascript_expansions[:defaults] = ['lib/jquery-1.4.2', 'jquery-ujs/src/rails']

  end
end

Haml::Template.options[:format] = :html5

