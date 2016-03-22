class NotificationsController < ApplicationController
  before_action :set_notifications
  after_action :mark_notifications_as_read
  def index; end

  private
    def set_notifications
      @notifications = Notification.where(user_id: current_user).order('created_at DESC')
    end
    def mark_notifications_as_read
      @unread = Notification.where(user_id: current_user, read: false)
      @unread.each do |n|
        n.read = true
        n.save
      end
    end
end
