# exception_notifier
#
LeetdemosPlatform::Application.config.middleware.use ExceptionNotifier,
  :sender_address => %("1337demos exception notifier" <exception-notifier@1337demos.com>),
  :exception_recipients => %w(1337demos@freshthinking.de),
  :ignore_exceptions => ExceptionNotifier.default_ignore_exceptions + [
    ActionController::InvalidAuthenticityToken
  ]

