module FlexRating

  def self.included(base)
    base.has_many :ratings, :as => :rateable, :dependent => :destroy
  end



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

end