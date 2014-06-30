require 'apn_connection'

class NotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  APN_POOL = ConnectionPool.new(size: 2, timeout: 300) do
    APNConnection.new
  end

  def perform(message, recipient_ids, custom_data = nil)
    recipient_ids = Array(recipient_ids)

    APN_POOL.with do |connection|
      tokens = User.where(id: recipient_ids).collect {|u| u.devices.collect(&:token)}.flatten

      tokens.each do |token|
        notification = Houston::Notification.new(device: token)
        notification.alert = message
        notification.sound = 'default'
        notification.custom_data = custom_data
        connection.write(notification.message)
      end
    end
  end
end
