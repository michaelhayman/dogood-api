require 'houston'

class Notification
  def self.send_url(token, message, url)
    if Rails.env.production?
      APN = Houston::Client.production
      APN.certificate = File.read("config/apple_push_notification_production.pem")
    else
      APN = Houston::Client.development
      APN.certificate = File.read("config/apple_push_notification_development.pem")
    end

    notif = Houston::Notification.new(device: token)
    notif.alert = message
    notif.badge = 0
    notif.content_available = true
    notif.custom_data = { url: url }
    APN.push(notif)
  end
end

