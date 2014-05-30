class Follow < ActiveRecord::Base

  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface,
  # and also to followers
  belongs_to :followable,
    :polymorphic => true,
    :counter_cache => :cached_followers_count
  # add another counter_cache column
  belongs_to :follower,
    :polymorphic => true,
    :counter_cache => :cached_following_count

  def block!
    self.update_attribute(:blocked, true)
  end
end
