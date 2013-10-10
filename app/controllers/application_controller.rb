class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery


  protected

  def page_param
    page = params[:page].to_i
    page > 0 ? page : 1
  end

end

