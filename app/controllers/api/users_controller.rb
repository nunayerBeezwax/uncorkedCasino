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
			@user.set_gravatar_url	
			render json: @user
		end

		def destroy
			User.find(params[:id]).destroy
			render :nothing => true, :status => 204
		end

		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end

	end
end
