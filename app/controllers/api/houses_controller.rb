module Api
	class HousesController < ApplicationController
		respond_to :json
		def index
			if params[:games] == 'all'
				render json: House.first.games
			elsif params[:games] == 'blackjack'
				report = {}
				Game.where(name: "blackjack").each do |g|
					g.tables.each do |t|
						 report[ "Table #" + t.number.to_s] = (t.seat_qty - t.vacancies.length).to_s+ "/" + t.seat_qty.to_s
					end
				end
				render json: report.to_json.to_s.gsub!(/\"/, '\'')
			end
		end
	end
end