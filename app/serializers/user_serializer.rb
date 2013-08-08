class UserSerializer < ActiveModel::Serializer
  attributes :id, :is_current_user

  def is_current_user
    object.id == current_user.id
  end
end
