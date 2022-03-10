class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    user = User.find_by(email: auth_params[:email])
    render json: {message: "Can not find user with input email"} if user.nil?

    user.update_column :login_token, auth_token
    hash_authen = {
      status: true,
      data: {
        token: auth_token
      }
    }
    render json: hash_authen
  rescue ExceptionHandler::AuthenticationError
    render json: {message: Message.invalid_credentials}, status: :bad_request
  end

  def logout
    @current_user.update_column :login_token, nil
    render json: {message: "Logout successfully", success: true}, status: :ok
  end

  private

  def auth_params
    params.permit :email, :password
  end
end
