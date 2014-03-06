class NomineeDecorator < BaseDecorator
  include Api::Helpers::DecoratorHelper

  decorates Nominee

  def avatar_url
    "hey"
  end
end

