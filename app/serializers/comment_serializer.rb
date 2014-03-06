class CommentSerializer < ActiveModel::Serializer
  attributes :comment,
    :created_at

  has_many :entities, :as => :entityable

  has_one :user, serializer: UserSerializer
end
