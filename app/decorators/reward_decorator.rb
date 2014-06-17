class RewardDecorator < BaseDecorator
  decorates Reward

  def teaser
    object.teaser.url
  end
  memoize :teaser

  def within_budget
    if helpers.logged_in?
      helpers.dg_user.points >= object.cost
    else
      false
    end
  end
  memoize :within_budget
end

