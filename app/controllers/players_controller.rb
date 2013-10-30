class PlayersController < ApplicationController

	def index
		@players = Player.all(:include => ['main_nickname'])
    @demo_cnt = DemosPlayer.count(:group => :player_id)

    @players = @players.reject { |p| @demo_cnt[p.id].nil? || @demo_cnt[p.id] <= 0 }
		@players.sort! { |x,y| @demo_cnt[y.id] <=> @demo_cnt[x.id] }
	end

	def show
		@player = Player.find(params[:id], :include => 'nicknames')
		@title = "demos of #{@player}"
		@aliases = (@player.nicknames - [@player.main_nickname]).map(&:nickname)

    @demos = Demo.includes(:map).
      data_correct.
      joins("JOIN demos_players AS dp ON dp.player_id = #{@player.id} AND dp.demo_id = demos.id").
      order('demos.created_at DESC').
      page(page_param).per(10)
	end

end

