class CommentsController < ApplicationController

	caches_action :index, :list, :cache_path => :cache_path.to_proc

	def index
		@comments = Comment.paginate(:page => page_param, :per_page => 20, :order => 'created_at DESC', :conditions => { :commentable_type => 'Demo' })
		@title = "latest comments"
	end
end
