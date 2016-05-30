json.array!(@unread) do |unread_notification|
  json.extract! unread_notification, :id, :message
end
