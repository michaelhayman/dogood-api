class GoodsController < ApplicationController
  def index
    @goods = Good.in_category(1).by_user(1).stream(current_user)
    respond_with @goods
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
    @good.evidence = params[:good][:evidence]

    if Good.just_created_by(current_user)
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

