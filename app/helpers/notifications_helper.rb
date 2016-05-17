module NotificationsHelper
  def unread
  	Notification.where({user_id: current_user, read: false })
  end
  def unread_notifications_link
	  link_to(unread.count.to_s+' reply'.pluralize(unread.count), notifications_path, class: 'unread-link highlight') + "<span class='separator'> | </span>".html_safe if unread.any?
  end
end
