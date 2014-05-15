module Api
	class HousesController < ApplicationController
		respond_to :json

		def index
			if params[:games] == 'all'
				render json: House.first.games
			elsif params[:games] == 'blackjack'
				availible_seats = []
				House.first.games.where(name: 'blackjack').tables.each do |table|
					availible_seats << table.vacancies
				end
			end
		end
	end
end