class Api::V1::UsersController < Api::V1::ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create! user_params
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {message: Message.account_created, auth_token: auth_token}
    render json: response, status: :ok
  end

  def update
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    if @current_user.nil?
      render json: {message: "Can't find this user"}, status: bad_request
    else
      update_user @current_user
    end
  end

  private
  def user_params
    params.permit :name, :email, :password, :password_confirmation
  end

  def update_params
    params.require :password_confirmation if params[:password].present?
    params.permit :name, :password, :password_confirmation
  end

  def update_user user
    user.update update_params
    render json: {message: "Update successfully"}, status: :ok
  rescue ActionController::ParameterMissing
    render json: {message: "Param missing: password_confirmation"},
                 status: :bad_request
  end
end
