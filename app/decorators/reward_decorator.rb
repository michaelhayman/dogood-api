class RewardDecorator < BaseDecorator
  include Api::Helpers::DecoratorHelper

  decorates Reward

  def teaser
    object.teaser.url
  end
end

