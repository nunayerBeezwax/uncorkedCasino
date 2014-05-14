class Api::SessionsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  before_filter :ensure_params_exist
  respond_to :json
  skip_before_filter :verify_authenticity_token

  devise :timeoutable, :timeout_in => 1440.minutes

  def create
    build_resource
<<<<<<< HEAD
    resource =  User.find_for_database_authentication(
      :username => params[:user][:username]
=======
   
    resource =  User.find_for_database_authentication(
      username: params[:user][:username]
>>>>>>> 580e8691626bed247a39df63aab8fc1101c6e52e
    )
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      render json: {
        success: true,
<<<<<<< HEAD
        auth_token: ApiKey.create(:user_id =>resource.id),
=======
        auth_token: ApiKey.create(user_id: resource.id),
>>>>>>> 580e8691626bed247a39df63aab8fc1101c6e52e
        email: resource.email
        # username too?
      }
      return
    end
    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
  end

  protected

    def ensure_params_exist
      return unless params[:user].blank?
      render json: {
        success: false,
        message: "missing user parameter"
      }, status: 422
    end

    def invalid_login_attempt
      warden.custom_failure!
      render json: {
        success: false,
        message: "Error with your login or password"
      }, status: 401
    end
end
