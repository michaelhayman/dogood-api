# encoding: UTF-8

class CurrentUserDecorator < Draper::Decorator
  extend Memoist

  delegate_all

  def commented_good_ids
    object.comments.pluck(:commentable_id)
  end
  memoize :commented_good_ids

  def good_commented?(good_or_good_id)
    if object.present?
      id = case good_or_good_id
        when Good
          good_or_good_id.id
        else
          good_or_good_id
      end

      !!self.commented_good_ids.include?(id)
    end
  end
  memoize :good_commented?
end

