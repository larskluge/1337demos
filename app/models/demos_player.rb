class DemosPlayer < ActiveRecord::Base
  belongs_to :demo
  belongs_to :player
end

