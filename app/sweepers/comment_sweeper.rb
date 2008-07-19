class CommentSweeper < ActionController::Caching::Sweeper

	# This sweeper is going to keep an eye on this model
	observe Comment

	def after_save(record)
		expire_cache_for(record)
	end

	def after_destroy(record)
		expire_cache_for(record)
	end

	private
	def expire_cache_for(record)
		expire_action(:controller => '/comments', :action => 'index')
		expire_fragment(%r{/comments/index*})
	end
end

