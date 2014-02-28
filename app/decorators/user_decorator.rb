# encoding: UTF-8

class UserDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates User

  def to_builder(options = {})
    builder.(self,
      :id,
      :full_name,
      :email
    )

    yield builder if block_given?

    builder
  end
end

