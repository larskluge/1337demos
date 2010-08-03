class AddGameToDemos < ActiveRecord::Migration
  def self.up
    add_column :demos, :game, :string, :limit => 20
    Demo.update_all("game = 'Warsow'", "game is null")
    add_index :demos, :game
  end

  def self.down
    remove_index :demos, :game
    remove_column :demos, :game
  end
end

