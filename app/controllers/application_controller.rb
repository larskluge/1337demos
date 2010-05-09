# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	# make flash messages cachable via cookie + js
	include CacheableFlash

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	#protect_from_forgery # :secret => 'c111bea13c2f699f239e338712b24a4f'

	layout 'layout_2008-07'


  # exception_notification
  #
  include ExceptionNotifiable

  def self.exceptions_to_treat_as_404
    super << ActionController::MethodNotAllowed
  end


	protected

  def page_param
    page = params[:page].to_i
    page > 0 ? page : 1
  end

end

