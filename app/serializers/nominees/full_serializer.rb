class Nominees::FullSerializer < ActiveModel::Serializer
  attributes :full_name,
    :avatar_url,
    :email,
    :phone,
    :user_id,
    :twitter_id,
    :facebook_id
end

