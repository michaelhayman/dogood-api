class SendNotification
  extend Resque::Plugins::ExponentialBackoff

  @backoff_strategy = [ 0, 60, 120, 300, 600, 900, 1200, 1800, 3600, 7200, 14400 ]
  @queue = :send_notification

  class << self
    def perform(user_id, message, url)
      Device.tokens_for(user_id).each do |token|
        Notification.send_url(token, message, url)
      end
    end
  end
end
