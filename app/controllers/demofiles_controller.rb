require 'tempfile'

class DemofilesController < ApplicationController

	def index
    redirect_to :action => :new
	end

	def new
		@title = 'upload'
		@demofile = Demofile.new
    @valid = true
	end

	def create
		@demofile = Demofile.instantiate_by_upload(params[:demofile])

		if @demofile.valid?
			dr = @demofile.read_demo

			# new demo
			demo = Demo.new :version => @demofile.version,
        :game => @demofile.game,
				:gamemode => @demofile.gamemode,
				:time => @demofile.time_in_msec

			# map
			map = Map.find_by_name(dr.mapname) || Map.new(:name => dr.mapname)

      ActiveRecord::Base.transaction do
        @demofile.save!
        map.save!

        demo.map = map
        demo.demofile = @demofile
        demo.save!

        redirect_to :controller => 'demos', :action => 'verify', :id => demo
      end
    else
      if @demofile.errors[:sha1].present? && (same_demo = @demofile.find_same_demo)
        flash[:notice] = 'You tried to upload this already uploaded demo :)'
        redirect_to(demo_path(same_demo))
      else
        render :action => 'new'
      end
		end
	end

end

