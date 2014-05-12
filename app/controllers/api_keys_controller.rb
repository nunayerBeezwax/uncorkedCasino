class ApiKeysController < ApplicationController
	before_filter :authorize
	
	def new
		if current_user.api_key
			current_user.api_key.destroy
		end
		@api_key = ApiKey.create(user_id: current_user.id)
		render "show" 
	end

	def authorize
		 redirect_to root_path, alert: "Not authorized" if !signed_in?
	end
end