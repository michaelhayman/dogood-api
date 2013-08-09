class GoodsController < ApplicationController
  def index
    @goods = Good.includes(:comments => :user).load

    @good_ids = @goods.map(&:id)

    @current_user_likes = current_user.
      votes.
      where(:votable_type => "Good",
            :votable_id => @good_ids).
      map(&:votable_id)

    @current_user_comments = current_user.
      comments.
      where(:commentable_type => "Good",
            :commentable_id => @good_ids).
      map(&:commentable_id)

    @goods.each do |g|
      g.current_user_likes = false
      # select?
      @current_user_likes.each do |l|
        if g.id == l
          g.current_user_likes = true
          break
        end
      end

      g.current_user_commented = false
      @current_user_comments.each do |c|
        if g.id == c
          g.current_user_commented = true
          break
        end
      end

    end

    respond_with @goods
  end
end

