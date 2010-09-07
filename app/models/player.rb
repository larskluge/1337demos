class Player < ActiveRecord::Base
  has_many :demos, :through => :demos_player
  has_many :demos_player, :dependent => :destroy

	has_many :nicknames
	belongs_to :main_nickname, :class_name => 'Nickname', :foreign_key => 'main_nickname_id'

	validates_presence_of :main_nickname_id, :on => :update
	validates_uniqueness_of :main_nickname_id

	def main_nickname_plain
		self.main_nickname.nickname.gsub(/\^([^\^])/){''}.gsub(/\^\^/, '^')
	end
  deprecate :main_nickname_plain

  def to_s(format = nil)
    main_nickname.to_s(format)
  end
end

