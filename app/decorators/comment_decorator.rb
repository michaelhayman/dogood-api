class CommentDecorator < BaseDecorator
  decorates Comment

  decorates_association :entities

  def comment
    object.comment
  end
end

