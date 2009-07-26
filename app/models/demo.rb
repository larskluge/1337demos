class Demo < ActiveRecord::Base
  include FlexRating


  @@video_width = 384
  @@video_height = 288
  cattr_reader :video_width, :video_height

  after_create :update_positions


  has_many :players, :through => :demos_player#, :autosave => true
  has_many :demos_player#, :autosave => true

  belongs_to :map
  belongs_to :demofile, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'


  validates_presence_of :map_id
  validates_presence_of :demofile_id
  validates_presence_of :title, :on => :update, :if => Proc.new{|demo| demo.gamemode == 'freestyle'}
  validates_associated :players, :on => :update

  def validate
    #logger.info "status: #{self.status}"
    if Rails.env == 'production' # ignore if demo file is not available in dev-mode
      errors.add(:status, 'can not be "rendered" without an existing video file') if self.status == :rendered && !File.exists?(self.video_filename)
    end
    #logger.info "error cnt: #{errors.count}"
  end

  def validate_on_update
    errors.add(:data_correct, "can't be empty") if self.data_correct.nil?
  end



  named_scope :race, :conditions => {:gamemode => "race", :data_correct => true}, :order => "time"
  named_scope :freestyle, :conditions => {:gamemode => "freestyle", :data_correct => true}


  named_scope :by_map, proc {|map_id| {:conditions => {:map_id => map_id, :gamemode => "race"}}}



  def <=>(o)
    return 0 if o.class != Demo || self.gamemode != o.gamemode

    case(self.gamemode)
    when "race"
      self.time <=> o.time
    else
      0
    end
  end


  def toplist
    map.demos.race.all :conditions => "position IS NOT NULL", :order => 'position'
  end

  def calc_position
    return nil if self.gamemode != 'race'

    logger.info "Calc position for demo#id #{self.id}"

    # demos = self.map.demos.race
    demos = Demo.race.by_map(self.map_id) + [self]
    demos.uniq!

    demos = demos.inject([]) do |list, d|
      logger.info("==================#{d.players.size}==#{d.time}=========")
      # player_id = d.players.first.id # it's ok, cause it's race (1 demo = 1 player)

      # list[player_id] ||= []
      # list[player_id][d.time] = d

      list << d
      list
    end

    # demos.map! do |d|
    #   d.compact.first # concider only best demo of player
    # end

    # if !demos.include?(self)
    #   self.position = nil
    #   return true
    # end

    times = demos.map(&:time).uniq.sort
    self.position = times.index(self.time) + 1

    true
  end

  def recalc_position
    calc_position
    pos = self.position
    logger.info("update demo #{self.id}.position = #{pos}")
    update_attribute(:position, pos)
  end

  def update_positions
    demos = Demo.race.by_map(self.map_id)
    demos.each(&:recalc_position)

    true
  end



  def rerender
    self.status = :uploaded
    save!
  end

  def video_exists?
    self.status == :rendered && File.exists?(self.video_filename)
  end

  def video_filename
    "#{SYS_VIDEOS}#{self.id}.mp4"
  end

  def video_url
    return "#{WEB_VIDEOS}#{self.id}.mp4" if self.video_exists?
  end

  def video_file
    self.id.to_s + ".mp4"
  end
end
