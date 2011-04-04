class WelcomesController < ApplicationController
  include Lib::PlayerInfo


  def index
    @title = ''
    @announcements = Announcement.all(:order => 'created_at DESC')
    @feed_url = 'http://feeds.feedburner.com/1337demos-news'

    @comment ||= Comment.new
    @comment.build_user(:name => player_info[:name], :mail_pass => player_info[:mail_pass]) unless @comment.user
    @shoutboxes = Comment.welcome.approved.order('created_at DESC').paginate(:page => page_param, :per_page => 5)
  end


  def create_comment
    @comment = Comment.create(params[:comment].merge(:commentable_type => 'Welcome'))

    if @comment && @comment.valid?
      persist_player_info(@comment)
      flash[:notice] = 'Comment was successfully created.'
      redirect_to root_path
    else
      self.index
      render :action => 'index'
    end
  end

end

