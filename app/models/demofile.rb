require 'digest/sha1'

class Demofile < ActiveRecord::Base
	has_one :demo
	attr_accessor :game, :gamemode, :version, :gamedir, :time_in_msec

  has_attached_file :file
  validates_attachment_presence :file
  validates_attachment_size :file, :in => 1..2.megabytes

  before_validation :generate_sha1, :on => :create

  validates_presence_of :sha1
  validates_uniqueness_of :sha1, :message => "File was already uploaded."

  validates_presence_of :read_demo, :message => 'is not a valid demo file'
  validates_presence_of :gamemode, :on => :create

  validate :validate_map, :on => :create
  validate :validate_players, :on => :create
  validate :validate_gamemode, :on => :create


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

    attrs_from_demo_reader = %w(game gamemode version gamedir time_in_msec)
    attrs = attrs_from_demo_reader.inject(HashWithIndifferentAccess.new) { |h,attr| h[attr] = dr.send(attr); h }

    cls.new(params.merge(attrs))
  end


	def attachment_data
		self.temp_data
	end

	def generate_sha1
		self.sha1 = Digest::SHA1.hexdigest(file.to_file.open.gets(nil)) if file?
	end

  def find_same_demo
    self.class.find_by_sha1(sha1).demo if sha1.present?
  end

	def read_demo
    @read_demo ||= begin
                     if file?
                       dr = DemoReader.parse(file.to_file.path)
                       dr if dr.valid
                     end
                   end
	end


  protected

  def validate_map
    if errors.count.zero?
      errors.add_to_base 'Could not detect a mapname!!' if read_demo.mapname.nil? || read_demo.mapname.empty?
    end
  end

  def validate_players
    if errors.count.zero?
      errors.add_to_base 'Could not find any players in this demofile!!' if read_demo.playernames.nil? || read_demo.playernames.compact.empty?
    end
  end

	def validate_gamemode
    if errors.count.zero?
      errors.add_to_base 'Could not detect the gamemode!!' if read_demo.gamemode.nil?
    end
	end

end

