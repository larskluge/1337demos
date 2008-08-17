class Demo < ActiveRecord::Base

	@@rating_range = 0..10
	cattr_reader :rating_range
	#acts_as_rated :no_rater => true, :rating_range => self.rating_range, :with_stats_table => true
	has_many :ratings, :as => :rateable, :dependent => :destroy


	# todo: make this better!
	# check key
	#
	def rating(key)
		key = key.to_s
		ratings.each do |r|
			return r if r.key == key
		end
		ratings.new :key => key
	end


	#belongs_to :player
	has_and_belongs_to_many :players
	belongs_to :map
	belongs_to :demofile, :dependent => :destroy
	has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'

	validates_presence_of :map_id
	validates_presence_of :demofile_id

	validates_presence_of :title, :on => :update, :if => Proc.new{|demo| demo.gamemode == 'freestyle'}

	validates_associated :players, :on => :update

	def validate
		#logger.info "status: #{self.status}"
		errors.add(:status, 'can not be "rendered" without an existing video file') if self.status == :rendered && !File.exists?(self.video_filename)
		#logger.info "error cnt: #{errors.count}"
	end

	def validate_on_update
		errors.add(:data_correct, "can't be empty") if self.data_correct.nil?
	end

	def position
		return nil if self.gamemode != 'race'

		pos = 0
		demos = self.map.demos
		return 1 if demos.length == 1

		demos = demos.sort { |x,y| x.time <=> y.time }.collect {|demo| demo unless demo.time == self.time && demo != self}.compact

		# just consider best time of each player
		known_players = []
		demos = demos.inject([]) do |list, demo|
			if demo.gamemode == 'race' && !known_players.include?(demo.players.first)
				known_players << demo.players.first
				list << demo
			end
			list
		end

		res = demos.index(self)
		res.nil? ? nil : 1 + res
	end

	def video_width
		384
	end
	def video_height
		288
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
