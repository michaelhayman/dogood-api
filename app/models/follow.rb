class Follow < ActiveRecord::Base

  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface,
  # and also to followers
  belongs_to :followable,
    :polymorphic => true,
    :counter_cache => :follows_count
  # add another counter_cache column
  belongs_to :follower,
    :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

  def self.following(type, id)
    @instance = type.
      constantize.
      find(id)
    @instance.follows_by_type(type).map(&:followable)
  end

end
