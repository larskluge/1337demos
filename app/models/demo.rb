class Demo < ActiveRecord::Base
  include FlexRating

  enum_attr :status, %w(^uploaded processing rendered)

  @@video_width = 384
  @@video_height = 288
  cattr_reader :video_width, :video_height



  has_many :players, :through => :demos_players, :autosave => true
  has_many :demos_players, :autosave => true, :dependent => :destroy

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
  validate :validate_presence_of_video_on_status_update
  validate :validate_data_correct, :on => :update



  default_scope :order => "demos.created_at DESC"

  scope :data_correct, where(:data_correct => true)
  scope :rendered, where(:status => :rendered)

  scope :race, data_correct.where(:gamemode => %w(race cpm vq3))
  scope :freestyle, data_correct.where(:gamemode => "freestyle")
  scope :warsow_race, where(:gamemode => "race")

  scope :by_map, proc {|map_id| warsow_race.where(:map_id => map_id)}




  def self.demos_for_map(map)
		all_demos = Demo.data_correct.find_all_by_map_id(map,
			:order => 'time, ratings.average DESC, demos.created_at DESC',
			:include => 'ratings')

		# just show best time of each player
		known_players = []
		all_demos.inject([]) do |list, demo|
			case demo.gamemode
			when 'race'
				if !known_players.include?(demo.players.first)
					known_players << demo.players.first
					list << demo
				end
			else
				list << demo
			end
			list
		end
  end



  def <=>(o)
    return 0 if o.class != Demo || gamemode != o.gamemode

    time.to_i > 0 ? time <=> o.time : 0
  end


  def toplist
    Demo.race.by_map(map_id).all :conditions => "position IS NOT NULL", :order => 'position'
  end

  def calc_position
    return nil if gamemode != 'race'

    demos = Demo.race.by_map(map_id)

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
    return times.index(time) + 1
  end

  def check_if_positions_need_update
    @trigger_update_demos_after_save = new_record? || data_correct_changed?

    true
  end

  def update_positions(force = false)
    if @trigger_update_demos_after_save || force
      demos = Demo.race.by_map(map_id)
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
    status = :uploaded
    save!
  end

  def video_exists?
    status == :rendered && File.exists?(video_filename)
  end

  def video_filename
    "#{SYS_VIDEOS}#{id}.mp4"
  end

  def video_url
    "#{WEB_VIDEOS}#{id}.mp4" if video_exists?
  end

  def video_file
    "#{id}.mp4"
  end


  protected

  def validate_presence_of_video_on_status_update
    if Rails.env == 'production' # ignore if demo file is not available in dev-mode
      errors.add(:status, 'can not be "rendered" without an existing video file') if status == :rendered && !File.exists?(video_filename)
    end
  end

  def validate_data_correct
    errors.add(:data_correct, "can't be empty") if data_correct.nil?
  end

end

