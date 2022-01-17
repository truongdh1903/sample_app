class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :check_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy User.where(activated: true),
                         items: Settings.item_per_page
  end

  def show
    @pagy, @microposts = pagy @user.microposts.latest_posts,
                              items: Settings.item_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "user_delete_failed"
    end
    redirect_to users_url
  end

  def following
    @title = t("following").capitalize
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t("followers").capitalize
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end
  private
  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def check_user
    @user = User.find_by id: params[:id]
    return if @user&.activated

    flash[:danger] = t "danger"
    redirect_to root_url
  end
end
