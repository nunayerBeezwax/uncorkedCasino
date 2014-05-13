module Api
	class UsersController < ApplicationController
	respond_to :json

		def show
			@user = User.find(params[:id])
			render json: @user
		end

		def update
			@user = User.find(params[:id])
			@user.update(user_params)
			render json: @user
		end

		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end

	end
end
