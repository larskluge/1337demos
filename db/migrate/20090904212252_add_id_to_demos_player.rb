class AddIdToDemosPlayer < ActiveRecord::Migration
  class DemosPlayer < ActiveRecord::Base; end

  def self.up
    add_column :demos_players, :id, :integer

    DemosPlayer.all.each_with_index do |dp,i|
      ActiveRecord::Base.connection.execute("UPDATE demos_players SET id=#{i+1} WHERE demo_id = #{dp.demo_id} and player_id = #{dp.player_id};");
    end
  end

  def self.down
    remove_column :demos_players, :id
  end
end

