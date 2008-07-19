class Nickname < ActiveRecord::Base
	belongs_to :player

	validates_presence_of :nickname
	validates_uniqueness_of :nickname
	validates_presence_of :player
end
