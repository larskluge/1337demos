class Nickname < ActiveRecord::Base
	belongs_to :player

	validates_presence_of :nickname
	validates_uniqueness_of :nickname
	validates_presence_of :player

  def to_s(format = nil)
    case format
    when :plain
      nickname_plain
    else
      nickname
    end
  end


  protected

  def nickname_plain
    nickname.gsub(/\^([^\^])/){''}.gsub(/\^\^/, '^')
  end
end

