class Admin::ShoutboxesController < ApplicationController
	requires_authentication :using => Proc.new{ |username, password| username == 'admin' && password == 'vip2067' },
													:realm => 'Secret Magic Happy Cloud'

	layout '/admin/application'

	# caching
	cache_sweeper :shoutbox_sweeper, :only => [:create, :update, :destroy]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }



  def index
    list
    render :action => 'list'
  end

  def list
    @shoutbox_pages, @shoutboxes = paginate :shoutboxes, :per_page => 10, :order => 'created_at DESC'
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
      redirect_to :action => 'list'
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
    redirect_to :action => 'list'
  end
end
