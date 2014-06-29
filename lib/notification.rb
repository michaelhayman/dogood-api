class Notification
  def self.send_url(token, message, url)
    notif = Houston::Notification.new(device: token)
    notif.alert = message
    notif.badge = 0
    notif.content_available = true
    notif.custom_data = { url: url }
    APN.push(notif)
  end
end

