class DemofileWarsow < Demofile

  validates_inclusion_of :version, :in => 9..11, :message => "must be a *.wd9, *.wd10, *.wd11 file"
  validate :validate_gamedir


  protected

  def validate_gamedir
    case gamedir
    when 'basewsw': true
    when 'racesow': true
    when /^racesow_local_0\.\w+$/: true
    else
      errors.add_to_base 'This mod of warsow is not supported. If you want request to support this mod with uploading it to Upload > Stuff upload'
    end
  end
end

