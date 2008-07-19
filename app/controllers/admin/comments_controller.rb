class Admin::CommentsController < Admin::ApplicationController

	# caching
	cache_sweeper :comment_sweeper, :only => [:create, :update, :destroy]

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :destroy, :create, :update ],
				 :redirect_to => { :action => :list }



	def index
		list
		render :action => 'list'
	end

	def list
		@comments = Comment.paginate(:page => params[:page],
			:per_page => 50, :order => 'updated_at DESC')
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
			redirect_to :action => 'list'
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
		redirect_to :action => 'list'
	end
end
