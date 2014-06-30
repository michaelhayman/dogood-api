class Follow < ActiveRecord::Base
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface,
  # and also to followers
  belongs_to :followable,
    polymorphic: true,
    counter_cache: :cached_followers_count

  # polymorphic counter caches update both relationships,
  # when we just want one.
  belongs_to :follower,
    polymorphic: true

  after_create :increment_following_counters
  after_destroy :decrement_following_counters

  [:increment, :decrement].each do |type|
    define_method("#{type}_following_counters") do
      follower_type.classify.constantize.send("#{type}_counter", "cached_following_count".to_sym, self.follower_id) if followable_type == "User"
    end
  end

  def block!
    self.update_attribute(:blocked, true)
  end

  def self.send_notification(followable, follower)
    if follower.present?
      if followable.is_a?(Good)
        message = "#{follower.full_name} followed your good post"
        url = "dogood://users/#{follower.id}"
        NotifierWorker.perform_async(message, followable.user_id, { url: url })
      end

      if followable.is_a?(User)
        message = "#{follower.full_name} followed you"
        url = "dogood://users/#{follower.id}"
        NotifierWorker.perform_async(message, followable.id, { url: url })
      end
    end
  end
end
