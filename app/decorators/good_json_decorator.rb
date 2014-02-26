# encoding: UTF-8

class GoodJSONDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper
  include Api::Helpers::JsonDecoratorHelper

  decorates Good

  def current_user_liked
    helpers.dg_user.good_liked?(object)
  end
  memoize :current_user_liked

  def current_user_regooded
    helpers.dg_user.good_regooded?(object)
  end
  memoize :current_user_regooded

  def current_user_commented
    helpers.dg_user.good_commented?(object)
  end
  memoize :current_user_commented

  def comments
    object.comments.first(5)
  end

  def evidence
    object.evidence.url
  end

  def likes_count
    object.cached_votes_up
  end
  memoize :likes_count

  def regoods_count
    object.follows_count
  end
  memoize :regoods_count

  def to_builder(options = {})
    builder.(self,
      :id,
      :caption,
      :likes_count,
      :comments_count,
      :regoods_count,
      :lat,
      :lng,
      :location_name,
      :location_image,
      :evidence,
      :done,
      :created_at,
      :entities,
      :current_user_commented,
      :current_user_liked,
      :current_user_regooded
    )
    builder.nominee self.nominee, :user_id, :full_name
    builder.user self.user, :id, :full_name
    builder.comments self.comments, :id, :comment, :user, :entities

    yield builder if block_given?

    builder
  end
end

