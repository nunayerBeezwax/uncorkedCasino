class RegistrationsController < Devise::RegistrationsController
	

	def destroy
		if current_user.api_key
			current_user.api_key.destroy
		end
		
		super
	end
end