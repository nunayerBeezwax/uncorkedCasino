module Api
	class GamesController < ApplicationController
			before_filter :restrict_access
			respond_to :json
		
		def index
			@games = Game.all
			render json: @games
		end

		private 

		def restrict_access
			authenticate_or_request_with_http_token do |token, options|
				ApiKey.exists?(access_token: token)
			end
		end

	end
end
