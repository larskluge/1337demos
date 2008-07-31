class Admin::ApplicationController < ApplicationController
	before_filter :authenticate


	layout 'admin'


	protected

	def authenticate
		authenticate_or_request_with_http_basic do |user, pass|
			user == 'admin' && Digest::MD5.hexdigest(pass) == "9c383927da6add23aa278e24eeaa5275"
		end
	end
end

