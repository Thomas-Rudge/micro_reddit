class SessionsController < ApplicationController

  def create
    @user = User.find_by(name: params[:session][:name].downcase)

    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to :back
    else
      flash[:danger] = "Unknown user/password combination."
      redirect_to :back
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to :back
  end
end
