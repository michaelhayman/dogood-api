class NomineeDecorator < BaseDecorator
  decorates Nominee
  decorates_association :user

  def avatar_url
    object.avatar.url
  end
  memoize :avatar_url
end

