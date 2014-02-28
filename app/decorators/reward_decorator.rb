# encoding: UTF-8

class RewardDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates Reward

  def to_builder(options = {})
    builder.(self,
      :id,
      :title
    )

    yield builder if block_given?

    builder
  end
end

