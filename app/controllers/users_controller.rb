class UsersController < ApplicationController
  def new
    redirect_to root_path unless current_user.guest?
    @user = current_user
  end

  def create
    @user = current_user
    @user.update(user_params)
    @user.guest = false
    if @user.save
      redirect_to '/'
    else
      @user.guest = true
      render 'new'
    end
  end

  def show
    if current_user.guest?
      redirect_to root_path 
    else
      @activity = Kaminari.paginate_array(
        if params[:show] == 'popular' 
          (current_user.convos + current_user.comments).sort_by(&:points).reverse
        else
          (current_user.convos + current_user.comments).sort_by(&:created_at).reverse
        end).page(params[:page]).per(25)
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      render 'edit'
    else
      redirect_to '/settings'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :guest)
    end
end
