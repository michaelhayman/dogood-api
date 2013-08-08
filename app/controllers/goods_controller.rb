class GoodsController < ApplicationController
  # before_filter :authenticate_user!

  def index
    authenticate_user!
    @goods = Good.all

    @goods.each do |g|
      g.current_user_likes = false
      if current_user.voted_on? g
        g.current_user_likes = true
      end
      g.current_user_commented = false
      if g.comments.find_comments_by_user(current_user).count > 0
        g.current_user_commented = true
      end
    end

    respond_with @goods
  end
end

