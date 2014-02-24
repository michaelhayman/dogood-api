# encoding: UTF-8

module Api::Helpers::JsonDecoratorHelper
  extend ActiveSupport::Concern

  included do
    extend Memoist

    memoize :builder
  end

  def builder
    context[:builder] || context[:json] || Jbuilder.new
  end
end

