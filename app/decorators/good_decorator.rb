# encoding: UTF-8

class GoodDecorator < Draper::Decorator
  extend Memoist

  decorates Good
  delegate_all

  def current_user_commented
    helpers.dg_user.listing_saved?(object)
  end
  memoize :current_user_commented

  # def good_commented?(good_or_good_id)
  #   if object.present?
  #     id = case good_or_good_id
  #       when Good
  #         good_or_good_id.id
  #       else
  #         good_or_good_id
  #     end

  #     !!self.commented_good_ids.include?(id)
  #   end
  # end
  # memoize :good_commented?
end

