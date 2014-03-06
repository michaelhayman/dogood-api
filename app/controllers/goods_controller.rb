class GoodsController < ApiController
  before_filter :setup_pagination, :only => [
    :index,
    :tagged,
    :popular,
    :nearby,
    :liked_by,
    :posted_or_followed_by,
    :nominations
  ]

  def index
    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).extra_info
    else
      @goods = Good.most_relevant.extra_info
    end

    render_paginated_index(@goods)
  end

  def show
    @good = Good.find(params[:id])
    render json: @good.decorate, root: "goods"
  end

  def tagged
    if params[:id] && params[:id] != "(null)"
      hashtag = SimpleHashtag::Hashtag.find(params[:id])
    elsif params[:name]
      hashtag = SimpleHashtag::Hashtag.find_by_name(params[:name])
    end

    hashtagged_elements = hashtag.hashtagged_ids_for_type("Good") if hashtag

    @goods = Good.where(:id => hashtagged_elements).
      extra_info.
      newest_first

    render_paginated_index(@goods)
  end

  def popular
    @goods = Good.
      popular.
      extra_info

    render_paginated_index(@goods)
  end

  def nearby
    @goods = Good.
      nearby(params[:lat], params[:lng]).
      extra_info

    render_paginated_index(@goods)
  end

  def liked_by
    @goods = Good.
      newest_first.
      liked_by_user(params[:user_id])

    render_paginated_index(@goods)
  end

  def posted_or_followed_by
    @goods = Good.
      newest_first.
      posted_or_followed_by(params[:user_id]).
      extra_info

    render_paginated_index(@goods)
  end


  def nominations
    @goods = Good.
      newest_first.
      nominations(params[:user_id]).
      extra_info

    render_paginated_index(@goods)
  end

  def create
    check_auth
    raise DoGood::Api::TooManyQueries.new if Good.just_created_by(dg_user)
    raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:good].present?

    @good = Good.new(resource_params)
    @good.user_id = current_user.id
    @good.evidence = resource_params[:evidence]

    if !@good.save
      if @good.errors
        message = @good.errors.full_messages
      else
        message = "Couldn't save the good."
      end
      raise DoGood::Api::RecordNotSaved.new(message)
    end
    render json: @good.decorate, root: "goods"
  end

  def resource_params
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id, :lat, :lng, :location_name, :location_image, :done, :nominee_attributes => [ :full_name, :email, :phone, :user_id, :twitter_id, :facebook_id ], :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params
end

