class RegistrationsController < Devise::RegistrationsController
	respond_to :json
	skip_before_filter :verify_authenticity_token, :only => :create

	def destroy
		if current_user.api_key
			current_user.api_key.destroy
		end
		super
	end

	




end