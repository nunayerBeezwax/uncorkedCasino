class ApiKeysController < ApplicationController

	def new
		@api_key = ApiKey.create()
		@api_key.update(user_id: current_user.id)
		respond_to do |f|
			f.js { render "show" }
		end
	end

end