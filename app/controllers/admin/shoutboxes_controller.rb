class Admin::ShoutboxesController < Admin::ApplicationController

  # caching
  cache_sweeper :shoutbox_sweeper, :only => [:create, :update, :destroy]



  def index
    @shoutboxes = Comment.paginate(:page => params[:page],
      :per_page => 10, :order => 'updated_at DESC', :conditions => { :commentable_type => 'Welcome' })
  end

  def show
    @shoutbox = Comment.find(params[:id])
  end

  def edit
    @shoutbox = Comment.find(params[:id])
  end

  def update
    @shoutbox = Comment.find(params[:id])
    if @shoutbox.update_attributes(params[:shoutbox])
      flash[:notice] = 'Shoutbox was successfully updated.'
      redirect_to :action => 'show', :id => @shoutbox
    else
      render :action => 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.json { render :text => '{success: true}', :status => 200 }
    end
  end
end

