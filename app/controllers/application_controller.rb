# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

	# make flash messages cachable via cookie + js
	include CacheableFlash

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	#protect_from_forgery # :secret => 'c111bea13c2f699f239e338712b24a4f'

	layout 'layout_2008-07'



	# extend caches_action to use a default cache path
	#alias true_caches_action caches_action
    #
	#def caches_action(*actions)
	#	options = actions.extract_options!
	#	options[:cache_path] = :cache_path.to_proc
	#	true_caches_action actions, options
	#end

	# extend cache 'expire_action' to make it work with and without layout rendering
	alias true_expire_action expire_action

	def expire_action(options = {})
		options = {} if options.nil?

		true_expire_action(options.merge({:layout => 'true'}))
		true_expire_action(options.merge({:layout => 'false'}))
	end



	protected

	def cache_path
		"#{controller_name}/#{action_name}/#{params[:page] || 1}"
	end

  def page_param
    page = params[:page].to_i
    page > 0 ? page : 1
  end
end

