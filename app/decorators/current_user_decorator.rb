# encoding: UTF-8

class CurrentUserDecorator < Draper::Decorator
  extend Memoist

  delegate_all

  def liked_good_ids
    object.
      votes.
      where(:votable_type => "Good").
      map(&:votable_id)
  end
  memoize :liked_good_ids

  def good_liked?(good_or_good_id)
    if object.present?
      id = get_id(good_or_good_id)

      !!self.liked_good_ids.include?(id)
    end
  end
  memoize :good_liked?

  def regooded_good_ids
    object.
      follows.
      where(:followable_type => "Good").
      map(&:followable_id)
  end
  memoize :regooded_good_ids

  def good_regooded?(good_or_good_id)
    if object.present?
      id = get_id(good_or_good_id)

      !!self.regooded_good_ids.include?(id)
    end
  end
  memoize :good_regooded?

  def commented_good_ids
    object.comments.pluck(:commentable_id)
  end
  memoize :commented_good_ids

  def good_commented?(good_or_good_id)
    if object.present?
      id = get_id(good_or_good_id)

      !!self.commented_good_ids.include?(id)
    end
  end
  memoize :good_commented?

  private
    def get_id(good_or_good_id)
      id = case good_or_good_id
        when Good
          good_or_good_id.id
        else
          good_or_good_id
      end
    end
end

