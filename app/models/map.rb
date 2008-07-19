class Map < ActiveRecord::Base
	has_many :demos

	#acts_as_rated :no_rater => true

	validates_presence_of :name
	validates_uniqueness_of :name
end
