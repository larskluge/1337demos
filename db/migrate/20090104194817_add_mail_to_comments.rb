class AddMailToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :mail, :string
  end

  def self.down
    remove_column :comments, :mail
  end
end
