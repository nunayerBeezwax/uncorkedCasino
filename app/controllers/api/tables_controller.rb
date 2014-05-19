module Api
	class TablesController < ApplicationController
		respond_to :json
		before_filter :identify_user

		def update
			@table = Table.find(params[:id])
			if params[:sit]
				identify_user.sit(@table)
				render json: @table
			elsif params[:bet]
				@table.bet(identify_user, params[:bet].to_i)
				render json: [identify_user.seat.placed_bet, identify_user.seat.cards, identify_user.table.cards]
			end
			
		end

private
		def identify_user
			ApiKey.find_by(access_token: params[:token]).user
		end
	end
end
