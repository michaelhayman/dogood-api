class UserDecorator < BaseDecorator
  decorates User

  def avatar_url
    object.avatar.url || ""
  end

  def current_user_following
    helpers.dg_user.user_followed?(object) || false
  end

  def followers_count
    object.follows_count
  end

  def following_count
    object.following_users_count
  end

  def liked_goods_count
    Good.liked_by_user(object.id).count
  end

  def posted_or_followed_goods_count
    Good.posted_or_followed_by(object.id).count
  end
end

