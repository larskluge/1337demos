class DemosPlayer < ActiveRecord::Base
  belongs_to :demo
  belongs_to :player

  validates_presence_of :demo_id
  validates_presence_of :player_id
end

