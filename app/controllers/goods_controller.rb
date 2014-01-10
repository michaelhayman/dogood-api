class GoodsController < ApplicationController
  before_filter :check_auth, only: :create
  before_filter :check_auth_silently,
    only: [
      :index,
      :tagged,
      :popular,
      :nearby,
      :liked_by,
      :posted_or_followed_by
    ]

  def index
    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).
        page(params[:page]).
        newest_first.
        extra_info
    elsif params[:good_id]
      @goods = Good.specific(params[:good_id]).
        page(params[:page]).
        newest_first.
        extra_info
    else
      @goods = Good.most_relevant.
        page(params[:page]).
        newest_first.
        extra_info
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
      page(params[:page]).
      extra_info.
      newest_first

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def popular
    @goods = Good.
      popular.
      page(params[:page]).
      extra_info

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def nearby
    @goods = Good.
      nearby(params[:lat], params[:lng]).
      page(params[:page]).
      extra_info

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
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
    @goods = Good.
      page(params[:page]).
      newest_first.
      posted_or_followed_by(params[:user_id]).
      extra_info

    if current_user
      @goods = Good.meta_stream(@goods, current_user)
    end
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
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id, :lat, :lng, :location_name, :location_image, :done, :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params

end

