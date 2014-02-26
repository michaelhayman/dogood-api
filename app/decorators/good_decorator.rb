# encoding: UTF-8

class GoodDecorator < Draper::Decorator
  extend Memoist

  decorates Good
  delegate_all
end

