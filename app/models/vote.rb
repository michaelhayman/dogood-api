class Vote < ActsAsVotable::Vote
  VOTE_POINTS = 2

  def self.send_notification(good, user)
    message = "#{user.full_name} voted on your post"
    url = "dogood://good/#{good.id}"
    SendNotification.perform(good.user_id, message, url)
  end
end

