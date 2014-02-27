# encoding: UTF-8

class CommentJSONDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates Comment

  def comment
    object.comment
  end

  def to_builder(options = {})
    builder.(self,
      :comment
    )

    yield builder if block_given?

    builder
  end
end

