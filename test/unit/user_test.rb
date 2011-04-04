$LOAD_PATH << File.dirname(__FILE__) + '/..'
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "auto set mail attribute" do
    mail = 'me@aekym.com'
    user = User.new(:mail_pass => mail)

    assert_not_nil user.passphrase
    assert_equal mail, user.mail
  end

end

