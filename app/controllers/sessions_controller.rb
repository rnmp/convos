class SessionsController < ApplicationController
  skip_before_action :assign_current_user, :create
  def new
  end
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
      flash.now[:alert] = "email or password is incorrect."
      render :new
    end
  end

  def create_for_test_user
    session[:user_id] = nil
    user = User.find(params[:user][:id])
    session[:user_id] = user.id
    redirect_to :back
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
