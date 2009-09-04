class RemoveObsoletPlayerDemosEntries < ActiveRecord::Migration
  def self.up
    DemosPlayer.destroy_all("player_id NOT IN (SELECT id FROM players)")
  end

  def self.down
    # not possible
  end
end

