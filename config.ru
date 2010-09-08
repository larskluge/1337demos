# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Middleware
#
# LeetdemosPlatform::Application.config.middleware.use ExceptionNotifier,
#   :sender_address => %("1337demos exception notifier" <exception-notifier@1337demos.com>),
#   :exception_recipients => %w(1337demos@freshthinking.de)

run LeetdemosPlatform::Application

