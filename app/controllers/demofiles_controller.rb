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

		#d = Demo.new
		#render :text => Demo.methods.sort.join(', ')
	end

	def create
		demo, map, player, nickname = nil
		@demofile = Demofile.new(params[:demofile])
		@demofile.generate_md5

		if @demofile.valid?
			dr = @demofile.read_demo

			# new demo
			demo = Demo.new :version => dr.version,
				:gamemode => @demofile.gametype,
				:time => dr.time_in_msec

			# map
			map = Map.find_by_name(dr.mapname) || Map.new(:name => dr.mapname)

			#begin
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
			#rescue Exception => e
			#	@demofile.errors.add_to_base 'AAAAAAAAAAAAARG ' + e.message
			#end
    else
      same_id = @demofile.errors.on :duplicated_demo
      if same_id
        flash[:notice] = 'You tried to upload this already uploaded demo :)'
        return redirect_to(demo_path(same_id))
      end
		end

		render :action => 'new'
	end







=begin
	def create2
		ud = params[:demofile][:uploaded_data]
		file_sent = [String, StringIO].include?(ud.class) && ud.size == 0
		file_sent = !file_sent

		logger.info ".file_sent = #{file_sent.to_s}."

		@demofile = Demofile.new(params[:demofile])

		if file_sent
			demo = nil
			map = nil
			player = nil

			# read demo information
			out = Tempfile.new('tempfile')
			out << @demofile.attachment_data
			out.close
			dr = DemoReader.new out.path
			File.delete out.path

			flash[:notice] = 'Not a valid warsow demo file.' unless dr.valid
			flash[:notice] = 'Just supporting *.wd9 files atm.' if dr.valid && dr.version != 9
			if flash[:notice]
				redirect_to :action => 'new'
				return
			end







			# create demo
			demo = @demofile.create_demo :version => dr.version,
				:gamemode => dr.gamemode,
				:time => dr.time_in_msec

			# add map
			map = Map.find_by_name dr.mapname
			if map
				demo.map = map
			else
				demo.create_map :name => dr.mapname
			end

			# add demofile
			demo.demofile = @demofile

			if dr.player
				# add nickname
				nickname = Nickname.find_by_nickname dr.player
				if nickname
					demo.player = nickname.player
				else
					player = demo.create_player
					nickname = player.create_in_nicknames :nickname => dr.player
					player.main_nickname = player.nicknames.first
				end
			end






		end

		if @demofile.save && demo.save && (player.nil? || player.save)
			#flash[:notice] = 'Demo was successfully created.'
			redirect_to :controller => 'demos', :action => 'verify', :id => demo
		else
			render :action => 'new'
		end
	end
=end

end
