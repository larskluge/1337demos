class ShoutboxSweeper < ActionController::Caching::Sweeper
	observe Shoutbox # This sweeper is going to keep an eye on the Post model

	# NOTE: We can call "after_save", instead of "after_create" and "after_update" above, to dry out our code.

	# If our sweeper detects that a Post was created call this
	def after_create(record)
		expire_cache_for(record)
	end

	# If our sweeper detects that a Post was updated call this
	def after_update(record)
		expire_cache_for(record)
	end

	# If our sweeper detects that a Post was deleted call this
	def after_destroy(record)
		expire_cache_for(record)
	end

	private
	def expire_cache_for(record)

		expire_action(:controller => '/welcomes', :action => 'index')
		# and delete all pages
		expire_fragment(%r{/welcomes/index*})

		# Also expire the show page, incase we just edited a blog entry
		#expire_page(:controller => 'shoutbox', :action => 'show', :id => record.id)
	end
end

