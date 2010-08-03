require 'digest/sha1'

class Demofile < ActiveRecord::Base
	has_one :demo
	attr_accessor :game, :gametype, :gamemode, :version, :gamedir, :time_in_msec

	has_attachment :storage => :file_system, :max_size => 2.megabytes
	validates_as_attachment

  before_validation_on_create :generate_sha1

  validates_presence_of :sha1
  validates_uniqueness_of :sha1, :message => "File was already uploaded."

  validates_presence_of :read_demo, :message => 'is not a valid demo file'
  validates_presence_of :gametype, :gamemode


  # Instantiates an object of Demofile or a concrete subclass of it.
  # This is detected by the uploaded file.
  #
  def self.instantiate_by_upload(params)
    tmp = Demofile.new(params)

    dr = tmp.read_demo

    return tmp unless dr

    class_parts = ["Demofile", dr.game, dr.gamemode.camelize]

    cls = nil
    while cls.nil? && class_parts.present?
      cls_str = class_parts.join
      cls = cls_str.constantize rescue nil
      class_parts.pop
    end

    cls.new(params.merge(
      %w(game gamemode version gamedir time_in_msec).inject(HashWithIndifferentAccess.new) { |h,attr| h[attr] = dr.send(attr); h }
    ))
  end


	def validate_on_create
    return if errors.count > 0

    errors.add_to_base 'Could not detect a mapname!!' if read_demo.mapname.nil? || read_demo.mapname.empty?
    errors.add_to_base 'Could not find any players in this demofile!!' if read_demo.playernames.nil? || read_demo.playernames.compact.empty?
    errors.add_to_base 'Could not detect the gamemode!!' if read_demo.gamemode.nil?
	end

	def attachment_data
		self.temp_data
	end

	def generate_sha1
		self.sha1 = Digest::SHA1.hexdigest(temp_data) if temp_data.present?
	end

  def find_same_demo
    self.class.find_by_sha1(sha1).demo if sha1.present?
  end

	def read_demo
    @read_demo ||= begin
                     if File.exists?(temp_path)
                       dr = DemoReader.parse(self.temp_path)
                       dr if dr.valid
                     end
                   end
	end

end

