class PlayersController < ApplicationController

	# caching
	caches_action :index, :cache_path => :cache_path.to_proc



	def index
		@players = Player.find :all,
			:include => ['demos', 'main_nickname']
      # :conditions => 'COUNT(demos.*) > 0'
    @players = @players.map { |p| p if p.demos.size > 0 }.compact
		@players.sort! { |x,y| y.demos.length <=> x.demos.length }
	end

	def show
		@player = Player.find(params[:id], :include => 'nicknames')
		@aliases = @player.nicknames - [@player.main_nickname]
		@demos = Demo.paginate :page => params[:page],
			:per_page => 10,
			:include => :map,
			#:conditions => ['data_correct AND player_id = ?', @player.id],
			:conditions => 'data_correct',
			:joins => 'JOIN demos_players AS dp ON dp.player_id = %d AND dp.demo_id = demos.id' % @player.id,
			:order => 'demos.created_at DESC'
		@title = "demos of #{@player.main_nickname_plain}"
	end
end

