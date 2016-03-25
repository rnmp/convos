class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :assign_current_user, unless: :current_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def find_user_with_ip(ip)
    User.find{|u| u.ip == ip }
  end

  def assign_current_user
    ip = request.remote_ip
    existing_user = find_user_with_ip(ip)
    if existing_user
      session[:user_id] = existing_user.id
    else
      new_user = User.new_guest
      new_user.ip = ip
      new_user.save!
      session[:user_id] = new_user.id
    end
  end

  def authorize
    redirect_to '/login' unless current_user
  end
end
