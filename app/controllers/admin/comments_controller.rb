class Admin::CommentsController < Admin::ApplicationController

  # caching
  cache_sweeper :comment_sweeper, :only => [:create, :update, :destroy]



  def index
    @comments = Comment.paginate(:page => params[:page],
      :per_page => 50, :order => 'updated_at DESC', :conditions => { :commentable_type => 'Demo' })
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to :action => 'show', :id => @comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    respond_to do |format|
      #format.html { redirect_to :action => 'index' }
      format.json { render :text => '{success: true}', :status => 200 }
    end
  end
end
