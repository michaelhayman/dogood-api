class BaseDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper

  def self.collection_decorator_class
    DoGood::WillPaginateCollectionDecorator
  end
end

