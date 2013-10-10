require 'tempfile'

class StuffsController < ApplicationController

  before_filter :pseudo_login_required, :only => :index

	def index
    @stuffs = Stuff.all(:order => 'created_at DESC', :limit => 20)
    respond_to do |wants|
      wants.atom do
        render :layout => false
      end
    end
	end



	def new
		@title = 'stuff upload'
		@stuff = Stuff.new
    comment = Comment.new
    comment.user = User.new
    @stuff.comments = [comment]
	end

	def create
    @stuff = Stuff.new(params[:stuff])
    if @stuff.valid? && @stuff.save
      redirect_to thanks_stuffs_path
    else
      render :action => 'new'
    end
	end

  def thanks
  end



  protected

  def pseudo_login_required
    if params[:format] != 'atom' || params[:appsec] != 'f00bar'
      redirect_to new_stuff_path
      return false
    end
  end

end
