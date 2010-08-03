class DemofileWarsowRace < Demofile

  validates_format_of :gamemode, :with => /^race$/
  validates_numericality_of :time_in_msec, :greater_than => 0

  alias :time_in_msec_before_type_cast :time_in_msec

end

