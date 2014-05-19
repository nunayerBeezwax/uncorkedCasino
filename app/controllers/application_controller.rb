class ApplicationController < ActionController::Base
	
before_filter :restrict_access
before_filter :configure_permitted_parameters, if: :devise_controller?
protect_from_forgery with: :null_session
 

private

def restrict_access
	unless  ApiKey.exists?(access_token: params[:token])
	  authenticate_or_request_with_http_token do |token, options|
	  	ApiKey.exists?(access_token: token)
	  end
	end
end

protected
  def configure_permitted_parameters
     devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
     devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
     devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end

  
