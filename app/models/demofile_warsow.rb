class DemofileWarsow < Demofile

  validates_format_of :game, :with => /^Warsow$/
  validates_inclusion_of :version, :in => 9..11, :message => "must be a *.wd9, *.wd10, *.wd11 file"
  validates_inclusion_of :gamemode, :in => %w(race freestyle)
  validate :validate_gamedir

  def gamemode
    time_in_msec.to_i > 0 ? "race" : "freestyle"
  end


  protected

  def validate_gamedir
    case gamedir
    when 'basewsw' then true
    when 'racesow' then true
    when /^racesow_local_0\.\w+$/ then true
    else
      errors.add_to_base 'This mod of warsow is not supported. If you want request to support this mod with uploading it to Upload > Stuff upload'
    end
  end
end

