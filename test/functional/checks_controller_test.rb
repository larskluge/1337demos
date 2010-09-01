$LOAD_PATH << File.dirname(__FILE__) + '/..'
require "test_helper"

class ChecksControllerTest < ActionController::TestCase

  test "if /check/fail throws an exception" do
    assert_raise Exception do
      get :fail
    end
  end

end

