class FixDemoPosition < ActiveRecord::Migration
  def self.up
    Demo.race.all(:group => :map_id).each do |d|
      d.update_positions
    end
  end

  def self.down
    # not possible
  end
end
