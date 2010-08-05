class WelcomesController < ApplicationController
  include PlayerInfo


  def index
    @title = ''
    @announcements = Announcement.all(:order => 'created_at DESC')
    @feed_url = 'http://feeds.feedburner.com/1337demos-news'

    @comment ||= Comment.new(:name => player_info[:name], :mail_pass => player_info[:mail_pass])
    @shoutboxes = Comment.paginate(:page => page_param, :per_page => 5, :order => 'created_at DESC', :conditions => {:commentable_type => 'Welcome'} )
  end


  def create_comment
    hash = params[:comment]
    hash.delete :token
    hash[:commentable_type] = 'Welcome'

    if (@comment = Comment.create(hash)) && @comment.valid?
      persist_player_info(@comment)
      flash[:notice] = 'Comment was successfully created.'
      redirect_to root_path
    else
      self.index
      render :action => 'index'
    end
  end

end

