module Api
	class TablesController < ApplicationController
		respond_to :json
		before_filter :identify_user

		def update
			@table = Table.find(params[:id])
			if params[:sit] == 'any'
				identify_user.sit(@table)
				render json: identify_user.state
			elsif params[:bet]
				identify_user.seat.place_bet(params[:bet].to_i)
				render json: [{"bet" =>identify_user.seat.placed_bet, "hand" => identify_user.seat.cards, "dealer hand" => @table.cards.first}]
			elsif params[:decision]
				if params[:decision] == "hit"
					@table.hit(identify_user)
					render json: identify_user.state
				elsif params[:decision] == "stand"
					@table.stand(identify_user)
					render json: identify_user.state
				end
			end
		end

private
		def identify_user
			ApiKey.find_by(access_token: params[:token]).user
		end
	end
end
