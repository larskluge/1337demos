class SetPrimaryKeyToDemosPlayers < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE `demos_players` CHANGE COLUMN `id` `id` int(11) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`);")
  end

  def self.down
    # not implemented
  end
end

