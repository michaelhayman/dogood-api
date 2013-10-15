class GoodsController < ApplicationController
  def index
    offset = calc_offset(params[:page])

    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).
        offset(offset).
        standard.
        extra_info(current_user)
    elsif params[:good_id]
      @goods = Good.specific(params[:good_id]).
        offset(offset).
        standard.
        extra_info(current_user)
    else
      @goods = Good.most_relevant.
        offset(offset).
        standard.
        extra_info(current_user)
    end

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def tagged
    offset = calc_offset(params[:page])

    if params[:id] && params[:id] != "(null)"
      hashtag = SimpleHashtag::Hashtag.find(params[:id])
    elsif params[:name]
      hashtag = SimpleHashtag::Hashtag.find_by_name(params[:name])
    end

    hashtagged_elements = hashtag.hashtagged_ids_for_type("Good") if hashtag

    @goods = Good.where(:id => hashtagged_elements).
      offset(offset).
      extra_info(current_user)
    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def liked_by
    @goods = Good.liked_by_user(params[:user_id])
    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def posted_or_followed_by
    @goods = Good.extra_info(current_user).
      standard.
      posted_or_followed_by(params[:user_id]).
       uniq
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

  private
    def calc_offset(page = 1)
      per_page = 10
      return (page.to_i - 1) * per_page
    end
end

