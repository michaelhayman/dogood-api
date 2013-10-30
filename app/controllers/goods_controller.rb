class GoodsController < ApplicationController
  def index
    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).
        page(params[:page]).
        newest_first.
        extra_info(current_user)
    elsif params[:good_id]
      @goods = Good.specific(params[:good_id]).
        page(params[:page]).
        newest_first.
        extra_info(current_user)
    else
      @goods = Good.most_relevant.
        page(params[:page]).
        newest_first.
        extra_info(current_user)
    end

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def tagged
    if params[:id] && params[:id] != "(null)"
      hashtag = SimpleHashtag::Hashtag.find(params[:id])
    elsif params[:name]
      hashtag = SimpleHashtag::Hashtag.find_by_name(params[:name])
    end

    hashtagged_elements = hashtag.hashtagged_ids_for_type("Good") if hashtag

    @goods = Good.where(:id => hashtagged_elements).
      page(params[:page])
      extra_info(current_user).
      newest_first
    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  # filter the last 2 days then sort by likes & re-goods
  def popular
    index
  end

  # find the good around you to do
  def nearby
    index
  end

  def liked_by
    @goods = Good.
      page(params[:page]).
      newest_first.
      liked_by_user(params[:user_id])

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def posted_or_followed_by
    @goods = Good.extra_info(current_user).
      page(params[:page]).
      newest_first.
      posted_or_followed_by(params[:user_id])

    @goods = Good.meta_stream(@goods, current_user)
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

