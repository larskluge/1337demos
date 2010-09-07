class PlayersController < ApplicationController

	def index
		@players = Player.all(:include => ['main_nickname'])
    @demo_cnt = DemosPlayer.count(:group => :player_id)

    @players = @players.reject { |p| @demo_cnt[p.id].nil? || @demo_cnt[p.id] <= 0 }
		@players.sort! { |x,y| @demo_cnt[y.id] <=> @demo_cnt[x.id] }
	end

	def show
		@player = Player.find(params[:id], :include => 'nicknames')
		@aliases = (@player.nicknames - [@player.main_nickname]).map(&:nickname)
		@demos = Demo.paginate :page => page_param,
			:per_page => 10,
			:include => :map,
			#:conditions => ['data_correct AND player_id = ?', @player.id],
			:conditions => 'data_correct',
			:joins => 'JOIN demos_players AS dp ON dp.player_id = %d AND dp.demo_id = demos.id' % @player.id,
			:order => 'demos.created_at DESC'
		@title = "demos of #{@player}"
	end

end

