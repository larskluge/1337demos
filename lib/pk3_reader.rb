class Pk3Reader

	def Pk3Reader.open(filename, &block)
		return if !File.exists?(filename) || !File.file?(filename)

		tmpdir = nil
		(1..100).each {|x|
			tmpdir = Dir.tmpdir + '/' + rand(10000000).to_s + '/'
			break unless File.exists?(tmpdir)
		}

		return nil if File.exists?(tmpdir)

		Dir.mkdir(tmpdir)
		system("unzip -qq #{filename} -d #{tmpdir}")

		exception = nil
		begin
			yield(Pk3Reader.new(tmpdir)) if block
		rescue Exception => e
			exception = e
		end

		system("rm -rf #{tmpdir}")

		raise(exception) if exception

		return nil
	end



	def dir
		return Dir.new(@tmpdir)
	end



	def maps
		begin
			Dir.entries(dir.path + 'maps/').inject([]) { |res, entry|
				entry =~ /^(.+)\.bsp$/ ? res.push($1) : res
			}
		rescue
			nil
		end
	end

	def mapfiles
		begin
			path = dir.path + 'maps/'
			Dir.entries(path).inject([]) { |res, entry|
				entry =~ /^.+\.bsp$/ ? res.push(path + entry) : res
			}
		rescue
			nil
		end
	end

	def texturefiles
		begin
			path = dir.path + 'textures/'
			Dir.entries(path).inject([]) { |res, entry|
				entry =~ /^.+\.(jpg|jpeg|tga)$/ ? res.push(path + entry) : res
			}
		rescue
			nil
		end
	end



	#protected
		def initialize(tmpdir)
			@tmpdir = tmpdir
		end

end

