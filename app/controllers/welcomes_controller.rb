class WelcomesController < ApplicationController

  caches_action :index, :cache_path => :cache_path.to_proc
  cache_sweeper :comment_sweeper, :only => [:create_comment]



  def index
    @title = ''
    @announcements = Announcement.all(:order => 'created_at DESC')
    # @shoutboxes = Shoutbox.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')
    @shoutboxes = Comment.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC', :conditions => {:commentable_type => 'Welcome'} )
  end



  def create_comment
    hash = params[:comment]
    hash.delete :token
    hash[:commentable_type] = 'Welcome'



    if (@comment = Comment.create(hash)) && @comment.valid?
      flash[:notice] = 'Comment was successfully created.'
      redirect_to root_path
    else
      self.index
      render :action => 'index'
    end
  end

end

