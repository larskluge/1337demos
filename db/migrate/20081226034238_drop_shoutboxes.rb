class DropShoutboxes < ActiveRecord::Migration
  def self.up
    drop_table(:shoutboxes) if table_exists?(:shoutboxes)
  end

  def self.down
  end
end
