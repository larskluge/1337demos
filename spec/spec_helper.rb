ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara-screenshot/rspec'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_localhost = true
  c.preserve_exact_body_bytes do |http_message|
    http_message.headers['Content-Type'].to_a.any?{|ct| ct =~ /^(image|binary)\//}
  end
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
  config.include FactoryGirl::Syntax::Methods

  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.use_transactional_fixtures = true

  Capybara.javascript_driver = :webkit

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around :each do |example|
    begin
      DatabaseCleaner.start
      example.run
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around :each, :vcr do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/[^\w\/]+/, '_')
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.run }
  end
end

