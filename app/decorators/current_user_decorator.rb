class CurrentUserDecorator < BaseDecorator
  extend Memoist

  delegate_all

  def voted_good_ids
    object.
      votes.
      where(votable_type: "Good").
      map(&:votable_id)
  end
  memoize :voted_good_ids

  def good_voted_on?(good_or_good_id)
    if object.present?
      id = get_id(good_or_good_id)

      !!self.voted_good_ids.include?(id)
    end
  end
  memoize :good_voted_on?

  def followed_good_ids
    object.
      follows.
      where(followable_type: "Good").
      map(&:followable_id)
  end
  memoize :followed_good_ids

  def good_followed?(good_or_good_id)
    if object.present?
      id = get_id(good_or_good_id)

      !!self.followed_good_ids.include?(id)
    end
  end
  memoize :good_followed?

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

  def followed_user_ids
    object.
      follows.
      where(followable_type: "User").
      map(&:followable_id)
  end
  memoize :followed_user_ids

  def user_followed?(user_or_user_id)
    if object.present?
      id = get_id(user_or_user_id)

      !!self.followed_user_ids.include?(id)
    end
  end
  memoize :user_followed?

  private
    def get_id(id_or_model)
      id = case id_or_model
        when User
          id_or_model.id
        when Good
          id_or_model.id
        else
          id_or_model
      end
      id
    end
end

