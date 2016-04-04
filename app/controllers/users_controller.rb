class UsersController < ApplicationController
  def new
    redirect_to root_path unless current_user.guest?
    @user = User.new
  end

  def create
    @user = params[:user] ? current_user : User.new
    @user.update(user_params)
    @user.guest = false
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  def show
    if current_user.guest?
      redirect_to root_path 
    else
    @activity = (current_user.convos + current_user.comments).sort_by(&:created_at).reverse
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
