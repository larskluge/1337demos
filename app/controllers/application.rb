# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'load_main_menu'

class ApplicationController < ActionController::Base

	# make flash messages cachable via cookie + js
	include CacheableFlash

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	#protect_from_forgery # :secret => 'c111bea13c2f699f239e338712b24a4f'

	layout 'layout_2008-07'



	#attr_accessor :mainmenu
	#before_filter LoadMainMenu

	helper_method :cache_path_mainmenu

	def self.mainmenu
		#Rails.cache.fetch('mainmenu') {
		#	self.load_recursive(Category.first({:conditions => '`published` = 1'}))
		#}

		Category.first({:conditions => '`published` = 1 AND name = "mainmenu"'})
	end





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



	# extend render to add global support to render all actions with/without layout
	alias true_render render

	def render(options = nil, extra_options = {}, &block)
		options = {} unless options
		options[:layout] = false if !params[:layout].nil? && params[:layout] == 'false'
		true_render options, extra_options, &block
	end



	protected

	def self.load_recursive(node)
		return if node.nil? || node.children.empty?

		node.children.each do |child|
			load_recursive child
		end
		return node
	end


	def cache_path
		"#{controller_name}/#{action_name}/#{params[:page] || 1}"
	end

	def cache_path_mainmenu
		"#{controller_name}/#{action_name}/mainmenu"
	end

end

