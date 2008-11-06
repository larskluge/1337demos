class AddTokenToComments < ActiveRecord::Migration
  def self.up
    add_column 'comments', 'token', :string, :limit => 32, :null => true, :default => nil
  end

  def self.down
    remove_column 'comments', 'token'
  end
end
