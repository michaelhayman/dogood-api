class CommentDecorator < BaseDecorator
  include Api::Helpers::DecoratorHelper

  decorates Comment

  decorates_association :entities

  def comment
    object.comment
  end
end

