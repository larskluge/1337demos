class Admin::PlayersController < ApplicationController
	requires_authentication :using => Proc.new{ |username, password| username == 'admin' && password == 'vip2067' },
													:realm => 'Secret Magic Happy Cloud'

	layout '/admin/application'

	# caching
	cache_sweeper :player_sweeper, :only => [:create, :update, :destroy]

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :destroy, :create, :update ],
				 :redirect_to => { :action => :list }



	def index
		list
		render :action => 'list'
	end

	def list
		@player_pages, @players = paginate :players, :per_page => 50, :order => 'created_at DESC'
	end

	def show
		@player = Player.find(params[:id])
	end

	def merge
		@player = Player.find(params[:id])
		@aliases = @player.nicknames
		@players = Player.find(:all) - [@player]
	end

	def merge_players
		main = Player.find(params[:source_player])
		tomerge = Player.find(params[:id].split('_')[1])

		if main.id > 0 && tomerge.id > 0
			# merge
			begin
				Demo.transaction do
					Player.transaction do
						demos = main.demos + tomerge.demos
						demos.uniq!
						main.demos = demos

						main.add_nicknames tomerge.nicknames
						main.save!

						tomerge.destroy_with_transactions
					end
				end
			rescue Exception => e
				render :text => 'Merge failed with message: ' + e.message
				return false
			end

			main.reload
			@aliases = main.nicknames
			render :partial => 'merge_players'
		else
			render :text => 'Could not merge players!!'
		end
	end

	def new
		@player = Player.new
	end

	def create
		@player = Player.new(params[:player])
		if @player.save
			flash[:notice] = 'Player was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new'
		end
	end

	def edit
		@player = Player.find(params[:id])
	end

	def update
		@player = Player.find(params[:id])
		if @player.update_attributes(params[:player])
			flash[:notice] = 'Player was successfully updated.'
			redirect_to :action => 'show', :id => @player
		else
			render :action => 'edit'
		end
	end

	def destroy
		Player.find(params[:id]).destroy
		redirect_to :action => 'list'
	end
end
