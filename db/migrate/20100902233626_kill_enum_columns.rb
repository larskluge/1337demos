class KillEnumColumns < ActiveRecord::Migration
  def self.up
    change_column :demos, :status, :string
    change_column :demos_players, :label, :string
  end

  def self.down
    # not implemented
  end
end

