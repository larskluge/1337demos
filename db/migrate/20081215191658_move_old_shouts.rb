class MoveOldShouts < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      Shoutbox.all.each do |s|
        c = Comment.new(s.attributes)
        c.commentable_type = 'Welcome'

        c.save_without_validation!

        s.destroy
      end
    end
  end

  def self.down
    # unimplemented
  end
end

