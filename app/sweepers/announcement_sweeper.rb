class AnnouncementSweeper < ActionController::Caching::Sweeper

	# This sweeper is going to keep an eye on this model
	observe Announcement

	def after_save(record)
		expire_cache_for(record)
	end

	def after_destroy(record)
		expire_cache_for(record)
	end

	private
	def expire_cache_for(record)
		expire_action(:controller => '/welcome', :action => 'index')
		expire_fragment(%r{/welcome/index*})
	end
end

