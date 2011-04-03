class MigrateUsers < ActiveRecord::Migration
  class Comment < ActiveRecord::Base; end
  class User < ActiveRecord::Base; end

  def self.up
    Comment.all.each do |c|
      user = User.new(
        :name => c.name,
        :mail => mail(c),
        :passphrase => passphrase(c)
      )
      found_user = User.find_by_name_and_passphrase(user.name, user.passphrase)

      if found_user
        user = found_user
      else
        user.save!
      end

      c.update_attribute(:user_id, user.id)
    end
  end

  def self.mail(comment)
    if comment.mail
      comment.mail
    else
      Comment.where(:name => comment.name, :mail.not_eq => nil).first.try(:mail)
    end
  end

  def self.passphrase(comment)
    if comment.token
      comment.token
    elsif comment.mail
      Digest::MD5.hexdigest(comment.mail)
    else
      comment_with_mail = Comment.where(:name => comment.name, :mail.not_eq => nil).first
      comment_with_token = Comment.where(:name => comment.name, :token.not_eq => nil).first

      if comment_with_mail
        passphrase(comment_with_mail)
      elsif comment_with_token
        passphrase(comment_with_token)
      else
        nil
        # Digest::MD5.hexdigest(rand.to_s)
      end
    end
  end

  def self.down
    User.delete_all
  end
end

