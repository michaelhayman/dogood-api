class GoodsController < ApplicationController
  def index
    # works for sure
    # @goods = Good.in_category(1).by_user(1).stream(current_user)
    # respond_with @goods

    # this one shows regoods etc due to 'stream' keyword
    # if (params[:category_id])
    # watch for goodID too
    # if params[:good_id]
    # if params[:good_id]
    #   @goods = Good.find_by_id(params[:good_id])
    # else
    # end
    # # this one doesn't
    # # @goods = Good.order('created_at desc').all

    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).by_user(1).stream(current_user)
    elsif params[:good_id]
      @goods = Good.find_by_id(params[:good_id])
    else
      @goods = Good.most_relevant.stream(current_user)
    end

    if @goods.present?
      respond_with @goods
    else
      render_errors("Couldn't find any good.")
    end
  end

  def liked_by
    @goods = Good.liked_by_user(params[:user_id])
    respond_with @goods
  end

  def posted_or_followed_by
    @goods = Good.posted_or_followed_by(params[:user_id])
    respond_with @goods
  end

  def create
    @good = Good.new(resource_params)
    @good.user_id = current_user.id
    @good.evidence = params[:good][:evidence]

    if Good.just_created_by(current_user).count > 0
      render_errors("Please wait longer before doing more good.")
      return
    end

    if @good.save!
      respond_with @good, root: "goods"
    else
      render_errors("Couldn't save the good.")
    end
  end

  def resource_params
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id)
  end
  private :resource_params
end

