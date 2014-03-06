class UserDecorator < BaseDecorator
  decorates User

  def avatar_url
    "hey"
  end
end

