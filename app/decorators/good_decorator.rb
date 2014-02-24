# encoding: UTF-8

class GoodDecorator < Draper::Decorator
  extend Memoist

  decorates Good
  delegate_all

  def current_user_commented
    helpers.dg_user.good_commented?(object)
  end
  memoize :current_user_commented
end

