# encoding: UTF-8

class TagDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates SimpleHashtag::Hashtag

  def to_builder(options = {})
    builder.(self,
      :id,
      :name
    )

    yield builder if block_given?

    builder
  end
end

