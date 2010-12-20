source 'http://rubygems.org'

gem 'rails', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'demo-reader', '>= 0.2.6'
gem 'enumerated_attribute'
gem 'exception_notification', :require => "exception_notifier", :git => "git://github.com/der-flo/exception_notification.git"
gem 'gravtastic', '>= 2.1.0'
gem 'haml', '>= 3'
gem 'mysql2'
gem 'newrelic_rpm'
gem 'paperclip'
gem 'rack'
gem 'will_paginate', '>= 3.0.pre2'

gem 'rmagick', '>= 2', :require => 'RMagick', :group => :development

gem "ruby-debug#{"19" if RUBY_VERSION >= "1.9"}", :group => [:test, :cucumber]

group :test do
  gem 'shoulda'
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'factory_girl'
  # gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end

