require 'tempfile'

class DemofilesController < ApplicationController

	caches_action :index, :new, :cache_path => :cache_path.to_proc

	def index
		new
		render :action => 'new'
	end

	def new
		@title = 'upload'
		@demofile = Demofile.new
    @valid = true
	end

	def create
		demo, map, player, nickname = nil
		@demofile = Demofile.instantiate_by_upload(params[:demofile])
    @valid = @demofile.valid?

		if @valid
			dr = @demofile.read_demo

			# new demo
			demo = Demo.new :version => @demofile.version,
				:gamemode => @demofile.gametype,
				:time => @demofile.time_in_msec

			# map
			map = Map.find_by_name(dr.mapname) || Map.new(:name => dr.mapname)

      ActiveRecord::Base.transaction do
        @demofile.save_with_validation!
        map.save_with_validation!

        demo.map = map
        demo.demofile = @demofile
        demo.save_with_validation!

        redirect_to :controller => 'demos', :action => 'verify', :id => demo
      end
    else
      if @demofile.errors.on(:sha1) && (same_demo = @demofile.find_same_demo)
        flash[:notice] = 'You tried to upload this already uploaded demo :)'
        redirect_to(demo_path(same_demo))
      else
        render :action => 'new'
      end
		end
	end

end

