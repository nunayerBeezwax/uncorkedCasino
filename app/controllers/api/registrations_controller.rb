module Api
	class RegistrationsController < Devise::RegistrationsController
	respond_to :json

		def create
			@user = User.create(user_params)
			@user.set_gravatar_url
			render json: @user
		end


		private
		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end

	end
end
