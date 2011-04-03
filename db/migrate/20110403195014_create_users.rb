class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :mail
      t.string :passphrase
      t.boolean :approved, :default => false

      t.timestamps
    end
    add_index :users, [:name, :passphrase], :unique => true
  end

  def self.down
    drop_table :users
  end
end

