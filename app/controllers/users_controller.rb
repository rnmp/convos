class UsersController < ApplicationController
  def new
    redirect_to root_path unless current_user.guest?
    @user = current_user
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
    @user.guest = false
    if @user.save
      redirect_to root_path
    else
      if @user.valid?
        render 'edit'
      else
        @user.guest = true
        render 'new'
      end
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
