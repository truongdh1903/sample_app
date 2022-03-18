class AuthorizeApiRequest < ApplicationController
  def initialize headers = {}
    @headers = headers
  end

  def call
    {user: user}
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find decoded_auth_token[:user_id] if decoded_auth_token
    raise ActiveRecord::RecordNotFound unless @user.login_token.eql? http_auth_header

    @user
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode http_auth_header
  end

  def http_auth_header
    if headers["Authorization"].present?
      return headers["Authorization"].split(" ").last
    end

    raise ExceptionHandler::MissingToken, Message.missing_token
  end
end
