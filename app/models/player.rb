class Player < ActiveRecord::Base
	has_and_belongs_to_many :demos
	has_many :nicknames
	belongs_to :main_nickname, :class_name => 'Nickname', :foreign_key => 'main_nickname_id'

	validates_presence_of :main_nickname_id, :on => :update
	validates_uniqueness_of :main_nickname_id

	def main_nickname_plain
		self.main_nickname.nickname.gsub(/\^([^\^])/){''}
	end
end
