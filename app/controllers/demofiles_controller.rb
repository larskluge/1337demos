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

		#d = Demo.new
		#render :text => Demo.methods.sort.join(', ')
	end

	def create
		demo, map, player, nickname = nil
		@demofile = Demofile.new(params[:demofile])
    @valid = @demofile.valid?

		if @valid
			dr = @demofile.read_demo

			# new demo
			demo = Demo.new :version => dr.version,
				:gamemode => @demofile.gametype,
				:time => dr.time_in_msec

			# map
			map = Map.find_by_name(dr.mapname) || Map.new(:name => dr.mapname)

      Demofile.transaction do
        Demo.transaction do
          Map.transaction do
            @demofile.save_with_validation!
            map.save_with_validation!

            demo.map = map
            demo.demofile = @demofile
            demo.save_with_validation!

            #flash[:notice] = 'Demo was successfully created.'
            redirect_to :controller => 'demos', :action => 'verify', :id => demo
            return
          end
        end
      end
    else
      if @demofile.errors.on :sha1
        same_demo = Demofile.find_by_sha1(@demofile.sha1).demo
        flash[:notice] = 'You tried to upload this already uploaded demo :)'
        return redirect_to(demo_path(same_demo))
      end
		end

		render :action => 'new'
	end

end

