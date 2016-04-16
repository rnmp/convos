module Report
  def report(item_path)
    @admins = User.admins
    @admins.each do |admin|
      @notification = Notification.new(message: 
        "Someone reported <a href='#{item_path}' target='_blank'>a #{self.class.to_s.downcase}</a>.".html_safe)
      @notification.user_id = admin.id
      @notification.save
    end
  end
end
