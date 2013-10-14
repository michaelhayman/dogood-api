class GoodsController < ApplicationController
  def index
    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).stream(current_user)
    elsif params[:good_id]
      @goods = Good.specific(params[:good_id]).stream(current_user)
    else
      @goods = Good.most_relevant.stream(current_user)
    end

    if @goods.present?
      respond_with @goods
    else
      render_errors("Couldn't find any good.")
    end
  end

  def tagged
    if params[:id] && params[:id] != "(null)"
      hashtag = SimpleHashtag::Hashtag.find(params[:id])
    elsif params[:name]
      hashtag = SimpleHashtag::Hashtag.find_by_name(params[:name])
    end

    hashtagged_elements = hashtag.hashtagged_ids_for_type("Good") if hashtag

    @goods = Good.where(:id => hashtagged_elements).stream(current_user)
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
    @good.user_id = current_user.id
    @good.evidence = params[:good][:evidence]

    if Good.just_created_by(current_user).count > 0
      render_errors("Please wait longer before doing more good.")
      return
    end

    if @good.save
      respond_with @good, root: "goods"
      @good.add_points
    else
      if @good.errors
        message = @good.errors.full_messages
      else
        message = "Couldn't save the good."
      end
      render_errors(message)
    end
  end

  def resource_params
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id, :lat, :lng, :location_name, :location_image, :done)
  end
  private :resource_params
end

