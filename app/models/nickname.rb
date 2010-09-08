class Nickname < ActiveRecord::Base
	belongs_to :player

	validates_presence_of :nickname
	validates_uniqueness_of :nickname
	validates_presence_of :player

  def to_s
    nickname_plain
  end


  protected

  def nickname_plain
    nickname.gsub(/\^([^\^])/){''}.gsub(/\^\^/, '^')
  end
end

