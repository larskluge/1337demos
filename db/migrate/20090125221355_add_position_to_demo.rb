class AddPositionToDemo < ActiveRecord::Migration
  def self.up
    Demo.transaction do
      add_column :demos, :position, :integer

      Demo.race.each do |d|
        d.save! # apply position with before_filter :calc_position
      end
    end
  end

  def self.down
    remove_column :demos, :position
  end
end
