class AccountActivationsController < ApplicationController
  skip_before_action :authorize_request
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      activate_redirect user
    else
      flash[:danger] = t "invalid_activation_link"
      redirect_to root_url
    end
  end

  def activate_redirect user
    user.activate
    log_in user
    flash[:success] = t "account_activated"
    redirect_to user
  end
end
