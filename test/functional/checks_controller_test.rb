require File.dirname(__FILE__) + '/../test_helper'

class ChecksControllerTest < ActionController::TestCase

  test "if /check/fail throws an exception" do
    assert_raise Exception do
      get :fail
    end
  end

end

