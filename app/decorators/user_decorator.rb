class UserDecorator < BaseDecorator
  decorates User

  def avatar_url
    object.avatar.url || ""
  end
  memoize :avatar_url

  def current_user_following
    helpers.dg_user.user_followed?(object) || false
  end
  memoize :current_user_following

  def followers_count
    object.cached_followers_count
  end
  memoize :followers_count

  def following_count
    object.cached_following_count
  end
  memoize :following_count

  def nominations_for_user_goods_count
    Good.nominations_for_user(object.id).count
  end
  memoize :nominations_for_user_goods_count

  def followed_goods_count
    Good.followed_by_user(object.id).count
  end
  # memoize :followed_goods_count

  def voted_goods_count
    Good.voted_by_user(object.id).count
  end
  memoize :voted_goods_count

  def nominations_by_user_goods_count
    Good.nominations_by_user(object.id).count
  end
  memoize :nominations_by_user_goods_count

  def help_wanted_by_user_goods_count
    Good.help_wanted_by_user(object.id).count
  end
  memoize :help_wanted_by_user_goods_count
end

