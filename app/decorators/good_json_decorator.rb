# encoding: UTF-8

class GoodJSONDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates Good

  def current_user_liked
    helpers.dg_user.good_liked?(object)
  end
  memoize :current_user_liked

  def current_user_regooded
    helpers.dg_user.good_regooded?(object)
  end
  memoize :current_user_regooded

  def current_user_commented
    helpers.dg_user.good_commented?(object)
  end
  memoize :current_user_commented

  def to_builder(options = {})
    builder.(object,
      :id,
      :caption
    )
    builder.current_user_commented current_user_commented
    builder.current_user_liked current_user_liked
    builder.current_user_regooded current_user_regooded

    yield builder if block_given?

    builder
  end
end

