require 'RMagick'

class MapsController < ApplicationController

	def index
		@mapsearch = session[:mapsearch]
		searchstr = '%%%s%%' % session[:mapsearch] || '%'
		@maps = Map.paginate(:page => page_param,
			:per_page => 12,
			:conditions => ["maps.name LIKE ?", searchstr],
			:order => 'name')

    @players = @maps.map do |m|
      demo = m.demos.first(:conditions => {:position => 1})
      demo.players.first if demo
    end
  end

	def search
		if params[:mapsearch] =~ /^[a-z0-9\-\#_]+$/i
			session[:mapsearch] = params[:mapsearch]
		else
			session[:mapsearch] = nil
		end
		redirect_to :action => 'index'
	end

	def clearsearch
		session[:mapsearch] = nil
		redirect_to :action => 'index'
	end

	def show
		@map = Map.find(params[:id])
		@title = "demos on #{@map.name}"
    @demos = Demo.demos_for_map(@map)
	end

	def thumb
		# allow only predefined sizes
		return unless ['200x150', '384x288'].include? params[:size]

		map = Map.find params[:id]

		filename = self.find_levelshot_file(map)
		levelshot_found = !filename.nil?

		nopreview_file = "#{SYS_MAP_IMAGE_THUMBS}#{params[:size]}/.nopreview.jpeg"

		if !levelshot_found
			if File.exists? nopreview_file
				# symlink to nopreview
				system "cd #{SYS_MAP_IMAGE_THUMBS}#{params[:size]} && ln -s \".nopreview.jpeg\" #{map.id}.jpeg"
			else
				# generate common nopreview-file
				filename = "#{SYS_MAP_IMAGES}../unknownmap.jpg" unless filename
			end
		end

		#return render :text => filename

		# generate thumb
		if filename
			width, height = params[:size].split('x').collect {|x| x.to_i}
			thumb = self.generate_thumbnail filename, width, height

			if thumb
				# write to file alias "cache" ;-)
				cachefile = levelshot_found ? "#{SYS_MAP_IMAGE_THUMBS}#{params[:size]}/#{map.id}.jpeg" : nopreview_file
				self.write_to_file cachefile, thumb[:binary]
			end
		end

		# redirect to same uri, because now the requested file exists
		redirect_to request.request_uri
	end



	protected
		def write_to_file(filename, binary)
			# write thumb to filesys
			out = File.new filename, 'w'
			out << binary
			out.close
		end

		def find_levelshot_file(map)
			filename = nil
			['jpg', 'tga', 'gif'].each { |ext|
				f = SYS_MAP_IMAGES + map.name + '.' + ext
				if File.exists? f
					filename = f
					break
				end
			}
			return filename
		end

		def generate_thumbnail(filename, width, height)
			return nil unless File.exists?(filename)

			img_orig = Magick::Image.read(filename).first
			#img = img_orig.resize_to_fit(width, height)
			img = img_orig.change_geometry('%dx%d!' % [width, height]) do |ncols, nrows, img|
				img.resize(ncols, nrows)
			end
			img.format = 'JPEG'

			{ :mime_type => img.mime_type,
				:binary => img.to_blob }
		end
end

