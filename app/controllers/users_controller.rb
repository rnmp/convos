class UsersController < ApplicationController
  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
