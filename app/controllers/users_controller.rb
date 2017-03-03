class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if verify_recaptcha(model: @user) && @user.save
      log_in @user
      redirect_to root_url
    else
      render "new"
    end
  end

  def delete
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :password,
                                   :password_confirmation)
    end
end
