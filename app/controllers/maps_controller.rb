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
    #
    size = params[:size]
    raise ActiveRecord::RecordNotFound unless ['200x150', '384x288'].include?(size)

    width, height = size.split('x').map(&:to_i)

    map = Map.find(params[:id])

    levelshot_file = map.find_levelshot_file
    levelshot_thumb_file = File.expand_path(File.join(SYS_MAP_IMAGE_THUMBS, size, "#{map.id}.jpeg")) # does not exist, will be generated

    no_preview_file = File.expand_path("#{SYS_MAP_IMAGES}../unknownmap.jpg")
    no_preview_thumb_file = File.expand_path(File.join(SYS_MAP_IMAGE_THUMBS, size, ".nopreview.jpg"))


    if levelshot_file
      # levelshot is available, so generate thumb
      #
      generate_thumb(levelshot_file, levelshot_thumb_file, width, height)
    else
      # levelshot is unavailable, so generate thumb from no-preview file
      #
      unless File.exists?(no_preview_thumb_file)
        generate_thumb(no_preview_file, no_preview_thumb_file, width, height)
      end

      # link requested file to no-preview thumb (cache for future requests)
      #
      File.symlink(no_preview_thumb_file, levelshot_thumb_file)
    end

    send_file levelshot_thumb_file, :type => 'image/jpeg', :disposition => 'inline'
  end


  protected

  def generate_thumb(src_file, dest_file, width, height)
    src_img = Magick::Image.read(src_file).first

    dest_img = src_img.change_geometry('%dx%d!' % [width, height]) do |ncols, nrows, img|
      img.resize(ncols, nrows)
    end
    dest_img.format = 'JPEG'

    # ensure directory path exists
    #
    FileUtils.mkdir_p(File.dirname(dest_file))

    dest_img.write(dest_file)

    # ensure image resize worked properly
    #
    raise "Generate thumbnail failed!" unless File.readable?(dest_file)
  end

end

