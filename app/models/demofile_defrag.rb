class DemofileDefrag < Demofile

  validates_format_of :game, :with => /^Defrag$/
  validates_numericality_of :version, :equal_to => 68, :message => "must be a *.dm68 file"
  validates_inclusion_of :gamemode, :in => %w(cpm vq3)

  # avoid bug that is triggered by calling validates_numericality_of on
  # an attribute (here version) that is not a column in the db table
  #
  alias :version_before_type_cast :version

end

