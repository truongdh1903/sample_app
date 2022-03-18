class Api::V1::ApplicationController < ActionController::API
  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    return @current_user unless @current_user.nil?

    render json: {message: Message.invalid_token}, status: :unauthorized
  end
end
