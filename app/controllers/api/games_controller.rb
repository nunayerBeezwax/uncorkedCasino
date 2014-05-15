module Api
	class GamesController < ApplicationController
			respond_to :json
		
		def index
			@games = Game.all
			render json: @games
		end
	end
end
