$LOAD_PATH << File.dirname(__FILE__) + '/..'
require 'test_helper'

class CheckFailTest < ActionDispatch::IntegrationTest
  test "if /check/fail throws an exception" do
    assert_difference "ActionMailer::Base.deliveries.size" do
      assert_raise Exception do
        get "/check/fail"
      end
    end
  end
end

