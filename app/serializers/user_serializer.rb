class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :avatar_url,
    :full_name
end
