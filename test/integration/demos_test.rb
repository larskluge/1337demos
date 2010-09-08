$LOAD_PATH << File.dirname(__FILE__) + '/..'
require 'test_helper'

class DemosTest < ActionDispatch::IntegrationTest
  test "atom feed" do
    Factory(:demo)

    get "/demos.atom"
    assert_response :success
  end
end

