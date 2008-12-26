class DropShoutboxes < ActiveRecord::Migration
  def self.up
    drop_table :shoutboxes
  end

  def self.down
  end
end
