class DemoSweeper < ActionController::Caching::Sweeper

	# This sweeper is going to keep an eye on this model
	observe Demo

	def after_save(record)
		expire_cache_for(record)
	end

	def after_destroy(record)
		expire_cache_for(record)
	end

	private
	def expire_cache_for(record)
		expire_action(:controller => '/demos', :action => 'index')
		expire_fragment(%r{/demos/index*})

		# this failes... dunno y! :-/
		#expire_action(:controller => '/demos', :action => 'rss')

		# so used this way
		expire_fragment(%r{/demos/rss*})
	end
end

