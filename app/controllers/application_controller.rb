class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :assign_current_user, unless: :current_user
  before_action :set_s3_direct_post
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    reset_session
    assign_current_user
  end
  helper_method :current_user

  def assign_current_user
    ip = request.remote_ip
    matching_user = User.where(ip: ip.to_s, guest: true)[0]
    unless matching_user
      new_guest_user = User.new_guest
      new_guest_user.ip = ip
      new_guest_user.save!
      matching_user = new_guest_user
    end
    session[:user_id] = matching_user.id
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "uploads/#{SecureRandom.uuid}/${filename}", 
      success_action_status: '201', 
      acl: 'public-read').content_type_starts_with('image/')
  end
end
