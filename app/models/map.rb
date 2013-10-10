class Map < ActiveRecord::Base
  include FlexRating
  attr_accessible :name

  has_many :demos

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end

  def get_first_player
    demos = self.demos.map { |d| d if d.gamemode == 'race' }.compact
    return if demos.empty?

    demos.sort { |x,y| x.time <=> y.time }.first.players.first
  end

  def find_levelshot_file
    filename = nil
    ['jpg', 'tga', 'gif'].each { |ext|
      f = SYS_MAP_IMAGES + name + '.' + ext
      if File.exists? f
        filename = f
        break
      end
    }
    filename
  end

end

