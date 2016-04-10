class UsersController < ApplicationController
  def new
    redirect_to root_path unless current_user.guest?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      current_user.transfer_items_to(@user) if current_user.guest?
      session[:user_id] = @user.id
      redirect_to root_path
    else
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
    def current_password_valid?
      @user.authenticate(params[:user][:current_password]) != false
    end
    if current_password_valid? && @user.update(user_params)
      redirect_to root_path
    else
      flash.now[:error] = 'your current password is not valid.' unless current_password_valid?
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :current_password)
    end
end
