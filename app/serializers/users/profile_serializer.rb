class Users::ProfileSerializer < ActiveModel::Serializer
  attributes :id,
    :avatar_url,
    :full_name,
    :location,
    :current_user_following,
    :followers_count,
    :following_count,
    :liked_goods_count,
    :rank,
    :followed_goods_count,
    :nominations_for_user_goods_count,
    :nominations_by_user_goods_count,
    :help_wanted_by_user_goods_count
end

