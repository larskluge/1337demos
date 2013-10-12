class DropStuff < ActiveRecord::Migration
  def change
    drop_table :stuffs
  end
end

