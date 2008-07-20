class SettingsController < ApplicationController
	@@video_players = ['flash', 'quicktime']



	def index
		show
		render :action => 'show'
	end

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
