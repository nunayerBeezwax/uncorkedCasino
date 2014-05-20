module Api
	class HousesController < ApplicationController
		respond_to :json
		before_filter :identify_user
		
		def index
			if params[:games] == 'all'
				render json: House.first.games
			elsif params[:games] == 'blackjack'
				report = {}
				Game.where(name: "blackjack").each do |g|
					g.tables.each do |t|
						 report[ "Table #" + t.number.to_s] = (t.seat_qty - t.vacancies.length).to_s + "/" + t.seat_qty.to_s
					end
				end
				render json: report.to_json.to_s.gsub!(/\"/, '\'')
			elsif params[:playgame] == "blackjack"
				identify_user.first_open(params[:playgame])
				render json: identify_user.state
			elsif params[:leavegame] == 'all'
				identify_user.leave_table
				render json: identify_user.to_json
			end
		end


private
		def identify_user
			ApiKey.find_by(access_token: params[:token]).user
		end
	end
end