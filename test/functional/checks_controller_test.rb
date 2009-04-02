require File.dirname(__FILE__) + '/../test_helper'

class ChecksControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "if /check/fail throws an exception" do
    exception_thrown = false

    begin
    get :fail
    rescue Exception => e
      exception_thrown = true
    end
    
    assert exception_thrown
  end
end
