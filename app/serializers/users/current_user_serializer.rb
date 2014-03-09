class Users::CurrentUserSerializer < ActiveModel::Serializer
  attributes :id,
    :full_name,
    :location,
    :biography,
    :full_name,
    :points,
    :avatar_url,
    :phone,
    :twitter_id,
    :facebook_id,
    :message

  def attributes
    data = super
    if data[:message] == nil
      data.delete(:message)
    else
      data = data.select {|k,v| [:message].include?(k) }
    end
    data
  end
end

