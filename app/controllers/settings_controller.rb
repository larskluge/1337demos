class SettingsController < ApplicationController
	@@video_players = ['flash', 'quicktime']

	def index
		show
		render :action => 'show'
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :update ],
				 :redirect_to => { :action => :show }

	def show
		@title = "settings"
		@video_players = @@video_players
		@video_player = (@@video_players.include?(session[:video_player])) ? session[:video_player] : @@video_players.first
	end

	def update
		session[:video_player] = params[:video_player] if @@video_players.include?(params[:video_player])

		flash[:notice] = 'Settings updated.'
		redirect_to :action => 'show'
	end
end
