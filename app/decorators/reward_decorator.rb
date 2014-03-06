class RewardDecorator < BaseDecorator
  decorates Reward

  def teaser
    object.teaser.url
  end
end

