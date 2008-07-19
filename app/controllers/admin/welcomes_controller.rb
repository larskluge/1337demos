class Admin::WelcomesController < Admin::ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
	  @demos = Demo.all :order => 'updated_at DESC', :conditions => 'data_correct IS NULL OR data_correct = 0'
  end

end

