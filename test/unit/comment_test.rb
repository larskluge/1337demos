$LOAD_PATH << File.dirname(__FILE__) + '/..'
require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "reuse user when creating a comment" do
    name = 'me'
    pass = 'foobar'

    user = User.create!(:name => name, :mail_pass => pass)

    comment = Comment.create!(
      :message => 'foo',
      :commentable_type => 'Welcome',
      :user_attributes => {
        :name => name,
        :mail_pass => pass
      }
    )

    assert_equal user.id, comment.user.id
    assert_equal name, comment.user.name
    assert_not_nil comment.user.passphrase
  end

end

