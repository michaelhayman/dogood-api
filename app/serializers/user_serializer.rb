class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :avatar_url,
    :full_name,
    :message

  def attributes
    data = super
    if data[:message] == nil
      data.delete(:message)
    else
      data.delete(:id)
      data.delete(:avatar_url)
      data.delete(:full_name)
    end
    data
  end
end
