class WelcomesController < ApplicationController

  def index
    @title = ''
    @announcements = Announcement.all(:order => 'created_at DESC')
    @feed_url = 'http://feeds.feedburner.com/1337demos-news'

    @comment ||= Comment.new
    @comment.build_user unless @comment.user
    @shoutboxes = Comment.welcome.approved.order('created_at DESC').page(page_param).per(5)
  end


  def create_comment
    @comment = Comment.create(params[:comment].merge(:commentable_type => 'Welcome'))

    if @comment && @comment.valid?
      redirect_to root_path,
        :notice => @comment.user.approved? ? 'Thanks for your post.' : 'Thanks for your post, but I need to approve it manually to avoid spam.'
    else
      self.index
      render :action => 'index'
    end
  end

end

