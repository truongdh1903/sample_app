class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find_by followed_id: params[:followed_id]
    current_user.follow user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
    redirect_to user
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    redirect_to user
  end
end
