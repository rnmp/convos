class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def check_user
    unless current_user
      @ip = request.remote_ip
      if User.any?{|u| u.ip == @ip }
        @user = User.find{|u| u.ip == @ip }
        session[:user_id] = @user.id
      else
        @user = User.new_guest
        @user.ip = @ip
        @user.save!
        session[:user_id] = @user.id
      end
    end
  end

  def authorize
    redirect_to '/login' unless current_user
  end
end
