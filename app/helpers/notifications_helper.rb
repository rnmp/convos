module NotificationsHelper
  def unread_notifications
  	Notification.where({user_id: @current_user, read: false })
  end
  def unread_notifications_link
  	unread = unread_notifications.count
    if unread > 0
  	  link_to unread.to_s+' reply'.pluralize(unread), notifications_path, class: 'replies-link'
  	end
  end
end
