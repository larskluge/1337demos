# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  layout "layout_2008-07"

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

