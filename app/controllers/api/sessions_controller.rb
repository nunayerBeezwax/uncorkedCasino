module Api
	class SessionsController < ApplicationController
	respond_to :json

		def create
			@api_key = ApiKey.create
			render json: @api_key
		end
	end
end
