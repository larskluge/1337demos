require 'digest/md5'

class Demofile < ActiveRecord::Base
	belongs_to :demo
	attr_writer :gametype
	attr_reader :gametype

	@read_demo = nil
	@gametype = 'race'

	has_attachment :storage => :file_system, :max_size => 2.megabytes
	validates_as_attachment

  validate_on_create :validate_basegamedir
  validate_on_create :validate_gamedir



	def validate
			errors.add_to_base 'The demofile u try to upload is already online. :-)' if Demofile.find_by_md5_and_size(self.md5, self.size)
	end

	def validate_on_create
		# check wheather anyfile is uploaded
		if size.nil?
			errors.clear
			errors.add :uploaded_data, 'is empty - upload a demofile (*.wdX).'
		else
			errors.add :uploaded_data, 'is not a valid warsow demo file (*.wdX).' if read_demo.nil?
			errors.add_to_base 'Just supporting *.wd9 and *.wd10 files.' if read_demo && ![9, 10].include?(read_demo.version)

			return if errors.count > 0

			errors.add_to_base 'Could not detect a mapname!!' if read_demo.mapname.nil? || read_demo.mapname.empty?
			errors.add_to_base 'Could not find any players in this demofile!!' if read_demo.playernames.nil? || read_demo.playernames.compact.empty?
			errors.add_to_base 'Could not detect the gamemode!!' if read_demo.gamemode.nil?


			# checks gametype dependent
			case self.gametype
				when 'race'
					errors.add_to_base 'The gamemode of your demo is not "race"!!' if read_demo.gamemode != 'race'
					errors.add_to_base 'Your warsow race demo doesn\'t contain a finish time!!' if read_demo.time_in_msec.nil?
				when 'freestyle'
					#errors.add_to_base 'Freestyle gametype is not fully implemented ATM.' if false
				else
					errors.add_to_base 'Hu? Nice try. ;-)'
			end
		end
	end


	def attachment_data
		self.temp_data
	end

	def generate_md5
		return nil if size.nil?
		self.md5 = Digest::MD5.hexdigest(self.temp_data)
	end


	def read_demo
		return @read_demo unless @read_demo.nil?
		return nil if size.nil?

		# read demo information
		#out = Tempfile.new('tempfile')
		#out << self.temp_data
		#out.close
		#dr = DemoReader.new out.path
		#File.delete out.path

		dr = DemoReader.new self.temp_path

		@read_demo = dr if dr.valid
	end


  protected

  def validate_basegamedir
    errors.add_to_base 'Only warsow demos are supported atm. Please request to support your demo with uploading it to Upload > Stuff upload.' if read_demo.basegamedir != 'basewsw'
  end

  def validate_gamedir
    case read_demo.gamedir
    when 'basewsw': true
    when /^racesow_local_0\.\w+$/: true
    else
      errors.add_to_base 'This mod of warsow is not supported. If you want request to support this mod with uploading it to Upload > Stuff upload'
    end
  end
end

