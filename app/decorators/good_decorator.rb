class GoodDecorator < BaseDecorator
  decorates Good
  decorates_association :comments
  decorates_association :entities
  decorates_association :user
  decorates_association :nominee
  decorates_association :category

  def current_user_voted
    helpers.dg_user.good_voted_on?(object) || false
  end
  memoize :current_user_voted

  def current_user_followed
    helpers.dg_user.good_followed?(object) || false
  end
  memoize :current_user_followed

  def current_user_commented
    helpers.dg_user.good_commented?(object) || false
  end
  memoize :current_user_commented

  def evidence
    object.evidence.url
  end
  memoize :evidence

  def votes_count
    object.cached_votes_up
  end
  memoize :votes_count

  def followers_count
    object.cached_followers_count
  end
  memoize :followers_count

  def comments_count
    object.cached_comments_count
  end
  memoize :comments_count
end

