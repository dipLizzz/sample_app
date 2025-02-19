class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Trường hợp 1
  def new
  end

  def edit
  end

  def update
    if params[:user][:password].empty? # Trường hợp 3
      @user.errors.add(:password, "Can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params) # Trường hợp 4
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity # Trường hợp 2
    end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found"
      render "new", status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:password,
    :password_confirmation)
  end
  # filter user
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless @user && @user.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_url
    end
  end
end
