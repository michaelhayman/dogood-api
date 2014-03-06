class UserDecorator < BaseDecorator
  include Api::Helpers::DecoratorHelper

  decorates User

  def avatar_url
    "hey"
  end
end

