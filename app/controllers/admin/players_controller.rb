class Admin::PlayersController < Admin::ApplicationController

	def index
		@players = Player.paginate(:page => page_param,
			:per_page => 50, :order => 'created_at DESC')
	end

	def show
		@player = Player.find(params[:id])
	end

	def merge
		@player = Player.find(params[:id])
		@aliases = @player.nicknames
		@players = Player.all - [@player]
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

						main.nicknames << tomerge.nicknames
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
			redirect_to :action => 'index'
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
		redirect_to :action => 'index'
	end
end

