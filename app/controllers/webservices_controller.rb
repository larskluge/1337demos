class WebservicesController < ApplicationController
  APPSEC = '1CGBre7Rk36vjBfT8cVEhhXIjEGVaPpI'

  before_filter :authorized?

  # cache_sweeper :demo_sweeper, :only => [:update_demo]



  def render_request
    cnt = (params[:count] || 3).to_i

    timeout = 10.seconds
    @demos = Demo.all(:conditions => ['data_correct AND (status = "uploaded" OR (status = "processing" AND updated_at < ?))', Time.now - timeout],
        :order => 'created_at', :limit => cnt)

    Demo.transaction do
      @demos.each do |demo|
        demo.update_attributes(:status => 'processing')
      end
    end

    render :layout => false
  end

  def update_demo
    @demo = Demo.find(params[:id])

    if @demo.update_attributes(params[:demo])
      render :nothing => true
    else
      render :xml => @demo.errors.to_xml, :status => 400
    end
  end



  protected

  def authorized?
    # check authorization
    authorized = params[:appsec] == APPSEC

    render(:nothing => true, :status => 401) unless authorized
    return authorized
  end
end

