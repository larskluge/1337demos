class Admin::ShoutboxesController < Admin::ApplicationController

  # caching
  cache_sweeper :shoutbox_sweeper, :only => [:create, :update, :destroy]



  def index
    @shoutboxes = Shoutbox.paginate(:page => params[:page],
      :per_page => 10, :order => 'created_at DESC')
  end

  def show
    @shoutbox = Shoutbox.find(params[:id])
  end

  def new
    @shoutbox = Shoutbox.new
  end

  def create
    @shoutbox = Shoutbox.new(params[:shoutbox])
    if @shoutbox.save
      flash[:notice] = 'Shoutbox was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @shoutbox = Shoutbox.find(params[:id])
  end

  def update
    @shoutbox = Shoutbox.find(params[:id])
    if @shoutbox.update_attributes(params[:shoutbox])
      flash[:notice] = 'Shoutbox was successfully updated.'
      redirect_to :action => 'show', :id => @shoutbox
    else
      render :action => 'edit'
    end
  end

  def destroy
    Shoutbox.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.json { render :text => '{success: true}', :status => 200 }
    end
  end
end

