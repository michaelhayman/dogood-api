require 'apn_connection'

class NotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  APN_POOL = ConnectionPool.new(size: 2, timeout: 300) do
    APNConnection.new
  end

  REDIS = Redis.new

  def perform(message, recipient_ids, custom_data = nil)
    recipient_ids = Array(recipient_ids)

    APN_POOL.with do |connection|
      tokens = User.where(id: recipient_ids).collect {|u| u.devices.collect(&:token)}.flatten

      tokens.each do |token|
        digest = Digest::MD5.hexdigest("#{message}#{token}#{custom_data}")
        if REDIS.get(digest) != "sent"
          notification = Houston::Notification.new(device: token)
          notification.alert = message
          notification.sound = 'default'
          notification.custom_data = custom_data
          connection.write(notification.message)
          REDIS.set(digest, "sent")
          Rails.logger.info "#{digest} created."
        else
          Rails.logger.info "Already sent notification for this event."
        end
      end
    end
  end
end
