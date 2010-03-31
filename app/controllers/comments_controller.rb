class CommentsController < ApplicationController

	def index
		@comments = Comment.paginate(:page => page_param, :per_page => 20, :order => 'created_at DESC', :conditions => { :commentable_type => 'Demo' })
		@title = "latest comments"
	end

end

