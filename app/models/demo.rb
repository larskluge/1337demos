class Demo < ActiveRecord::Base
  include FlexRating


  @@video_width = 384
  @@video_height = 288
  cattr_reader :video_width, :video_height



  has_many :players, :through => :demos_player, :autosave => true
  has_many :demos_player, :autosave => true, :dependent => :destroy

  belongs_to :map
  belongs_to :demofile, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'



  # place callbacks after associations to avoid errors,
  # because autosave => true is also implemented by after_create callbacks!
  #
  before_save :check_if_positions_need_update
  after_save :update_positions


  validates_presence_of :map_id
  validates_presence_of :demofile_id
  validates_inclusion_of :game, :in => %w(Warsow Defrag)
  validates_associated :players, :on => :update
  validates_presence_of :players, :on => :update
  validates_inclusion_of :gamemode, :in => %w(race freestyle), :if => Proc.new{|demo| demo.game == "Warsow"}
  validates_inclusion_of :gamemode, :in => %w(freestyle cpm vq3), :if => Proc.new{|demo| demo.game == "Defrag"}
  validates_presence_of :title, :on => :update, :if => Proc.new{|demo| demo.gamemode == 'freestyle'}

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



  named_scope :race, :conditions => {:gamemode => %w(race cpm vq3), :data_correct => true}, :order => "time"
  named_scope :freestyle, :conditions => {:gamemode => "freestyle", :data_correct => true}


  named_scope :by_map, proc {|map_id| {:conditions => {:map_id => map_id, :gamemode => "race"}}}



  def <=>(o)
    return 0 if o.class != Demo || self.gamemode != o.gamemode

    time.to_i > 0 ? time <=> o.time : 0
  end


  def toplist
    Demo.race.by_map(self.map_id).all :conditions => "position IS NOT NULL", :order => 'position'
  end

  def calc_position
    return nil if self.gamemode != 'race'

    demos = Demo.race.by_map(self.map_id)

    # short cut for one demo
    return 1 if demos.size == 1


    demos_by_player = demos.inject([]) do |arr,d|
      player_id = d.players.first.id

      arr[player_id] ||= []
      arr[player_id][d.time] = d

      arr
    end.compact


    concider_demos = demos_by_player.map do |demos_of_one_player|
      demos_of_one_player.compact.sort.first
    end


    # demo was improved by same player
    return nil unless concider_demos.include?(self)


    times = concider_demos.map(&:time).sort
    return times.index(self.time) + 1
  end

  def check_if_positions_need_update
    @trigger_update_demos_after_save = new_record? || data_correct_changed?

    true
  end

  def update_positions(force = false)
    if @trigger_update_demos_after_save || force
      demos = Demo.race.by_map(self.map_id)
      demos.each do |d|
        pos = d.calc_position
        d.update_attribute(:position, pos)
      end
    end

    true
  end


  def human_version
    case game
    when "Warsow" then "wd#{version}"
    when "Defrag" then "dm_#{version}"
    end
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

