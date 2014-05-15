module Api
	class HousesController < ApplicationController
		respond_to :json

		def index
			if params[:games] == 'all'
				render json: House.all.first.games
			end

			
		end
	end
end