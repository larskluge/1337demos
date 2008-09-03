class WebservicesController < ApplicationController
	APPSEC = '1CGBre7Rk36vjBfT8cVEhhXIjEGVaPpI'

	cache_sweeper :demo_sweeper, :only => [:update_demo]



	def render_request
		return unless self.authorized?
		cnt = params[:count].to_i || 3

		timeout = 10 # 10 secs // 2 * 60 # 2 Minutes
		@feed_title = 'Render response'
		demo = nil
		Demo.transaction do
			@demos = Demo.find(:all, :conditions => ['data_correct AND (status = "uploaded" OR (status = "processing" AND updated_at < ?))', Time.now - timeout],
				:order => 'created_at', :limit => cnt)
			@demos.each do |demo|
				demo.status = 'processing'
				demo.save!
			end
		end

		#@demos = [demo].compact
		render :layout => false
	end

	def update_demo
		return unless self.authorized?

		@demo = Demo.find(params[:id])

		if @demo.update_attributes(params[:demo])
			render :nothing => true
		else
			render :xml => @demo.errors.to_xml, :status => '400 Bad request'
		end
	end



	protected
		def authorized?
			# check authorization
			authorized = params[:appsec] == APPSEC

			render(:nothing => true, :status => '401 Unauthorized') unless authorized
			return authorized
		end
end
