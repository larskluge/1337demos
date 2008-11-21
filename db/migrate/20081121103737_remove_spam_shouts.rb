class RemoveSpamShouts < ActiveRecord::Migration
  def self.up
    Shoutbox.all(:conditions => ["created_at > ?", "2008-11-19 00:00:00"]).each do |shout|
      shout.destroy unless shout.valid?
    end
  end

  def self.down
    # not possible
  end
end
