class GoodDecorator < BaseDecorator
  decorates Good
  decorates_association :comments
  decorates_association :entities
  decorates_association :user
  decorates_association :nominee
  decorates_association :category

  def current_user_liked
    helpers.dg_user.good_liked?(object) || false
  end
  memoize :current_user_liked

  def current_user_regooded
    helpers.dg_user.good_regooded?(object) || false
  end
  memoize :current_user_regooded

  def current_user_commented
    helpers.dg_user.good_commented?(object) || false
  end
  memoize :current_user_commented

  def evidence
    object.evidence.url
  end
  memoize :evidence

  def likes_count
    object.cached_votes_up
  end
  memoize :likes_count

  def regoods_count
    object.followers_count
  end
  memoize :regoods_count

  # def comments
  #   object.comments.first(5)
  # end
end

