require 'houston'

if Rails.env.production?
  APN = Houston::Client.production
  APN.certificate = File.read("config/apple_push_notification_production.pem")
else
  APN = Houston::Client.development
  APN.certificate = File.read("config/apple_push_notification_development.pem")
end
