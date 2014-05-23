class NomineeDecorator < BaseDecorator
  decorates Nominee
  decorates_association :user

  def avatar_url
    "hey"
  end
end

