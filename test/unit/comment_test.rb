$LOAD_PATH << File.dirname(__FILE__) + '/..'
require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  STANDARD_PARAMS = {
    :message => 'foo',
    :commentable_type => 'Welcome',
    :user_attributes => {
      :name => 'me',
      :mail_pass => 'foobar'
    }
  }

  test 'reuse user when creating a comment' do
    name = 'me'
    pass = 'foobar'
    user, comment = nil

    assert_difference 'User.count' do
      user = User.create!(STANDARD_PARAMS[:user_attributes])
      comment = Comment.create!(STANDARD_PARAMS)
    end

    assert_equal user.id, comment.user.id
    assert_equal STANDARD_PARAMS[:user_attributes][:name], comment.user.name
    assert_not_nil comment.user.passphrase
    assert_nil comment.user.mail
  end

  test 'new comment is not approved automatically' do
    comment = Comment.create!(STANDARD_PARAMS)
    assert_equal false, comment.user.approved?
  end

  test 'next comment is approved automatically when another is approved' do
    comment = Comment.create!(STANDARD_PARAMS)
    assert_equal false, comment.user.approved?
    comment.user.approve!
    assert_equal true, comment.user.approved?
  end

end

