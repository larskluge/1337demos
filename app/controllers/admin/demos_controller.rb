class Admin::DemosController < ApplicationController
	requires_authentication :using => Proc.new{ |username, password| username == 'admin' && password == 'vip2067' },
													:realm => 'Secret Magic Happy Cloud'

	layout '/admin/application'

	# caching
	cache_sweeper :demo_sweeper, :only => [:create, :update, :destroy]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }



  def index
    list
    render :action => 'list'
  end

  def list
    @demo_pages, @demos = paginate :demos, :per_page => 50, :order => 'updated_at DESC'
  end

  def show
    @demo = Demo.find(params[:id])
  end

  def new
    @demo = Demo.new
  end

  def create
    @demo = Demo.new(params[:demo])
    if @demo.save
      flash[:notice] = 'Demo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @demo = Demo.find(params[:id])
  end

  def update
    @demo = Demo.find(params[:id])
    if @demo.update_attributes(params[:demo])
      flash[:notice] = 'Demo was successfully updated.'
      redirect_to :action => 'show', :id => @demo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Demo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
