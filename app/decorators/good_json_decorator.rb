# encoding: UTF-8

class GoodJSONDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates Good

  def to_builder(options = {})
    builder.(object,
      :id,
      :caption
    )

    yield builder if block_given?

    builder
  end
end

