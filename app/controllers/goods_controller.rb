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
      g.current_user_likes = @current_user_likes.include?(g.id)
      g.current_user_commented = @current_user_comments.include?(g.id)
    end

    respond_with @goods
  end
end

