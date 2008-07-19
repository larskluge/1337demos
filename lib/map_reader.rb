class MapReader
	attr_reader :textures, :filename, :name

	def initialize(filename)
		@filename = filename
		@textures = []

		@name = File.basename(filename) =~ /^(.+)\.bsp$/ ? $1 : nil

		self.init()
	end

	def init
		file = File.new(filename)
		content = file.gets nil
		file.close

		# textures
		regex = /textures\/[^\0]+/
		matchdata = regex.match(content)
		while matchdata
			@textures.push matchdata[0]
			matchdata = regex.match(matchdata.post_match)
		end
	end

end

