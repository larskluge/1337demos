class Map < ActiveRecord::Base

	include FlexRating

	has_many :demos

	#acts_as_rated :no_rater => true

	validates_presence_of :name
	validates_uniqueness_of :name



	def get_first_player
		demos = self.demos.map { |d| d if d.gamemode == 'race' }.compact
		return if demos.empty?

		demos.sort { |x,y| x.time <=> y.time }.first.players.first
	end

end
