class GoodsController < ApiController
  before_filter :setup_pagination, :only => [
    :index,
    :tagged,
    :popular,
    :nearby,
    :nominations_for,
    :followed_by,
    :liked_by,
    :nominations_by,
    :help_wanted_by
  ]

  def index
    @goods = apply_scopes(Good.extra_info)

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

    @goods = apply_scopes(@goods)

    render_paginated_index(@goods)
  end

  def popular
    @goods = apply_scopes(Good.
      popular.
      extra_info)

    render_paginated_index(@goods)
  end

  def nearby
    @goods = apply_scopes(Good.
      nearby(params[:lat], params[:lng]).
      newest_first.
      extra_info)

    render_paginated_index(@goods)
  end

  def nominations_for
    @goods = Good.
      newest_first.
      nominations_for_user(params[:user_id]).
      extra_info

    render_paginated_index(@goods)
  end

  def followed_by
    @goods = apply_scopes(Good.
      newest_first.
      followed_by_user(params[:user_id]).
      extra_info)

    render_paginated_index(@goods)
  end

  def liked_by
    @goods = apply_scopes(Good.
      newest_first.
      liked_by_user(params[:user_id]))

    render_paginated_index(@goods)
  end

  def nominations_by
    @goods = Good.
      newest_first.
      nominations_by_user(params[:user_id]).
      extra_info

    render_paginated_index(@goods)
  end

  def help_wanted_by
    @goods = Good.
      newest_first.
      help_wanted_by_user(params[:user_id]).
      extra_info

    render_paginated_index(@goods)
  end

  def create
    check_auth
    raise DoGood::Api::TooManyQueries.new if Good.just_created_by(dg_user)
    raise DoGood::Api::ParametersInvalid.new("No parameters.") unless params[:good].present?

    @good = Good.new(resource_params)
    @good.user_id = current_user.id
    @good.evidence = resource_params[:evidence]

    if @good.save
      render json: @good.decorate, root: "goods"
      if @good.send_invite?
        InviteMailer.invite_nominee(@good.nominee, @good.user).deliver
      end
    else
      message = @good.errors.full_messages.first || "Couldn't save good."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def resource_params
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id, :lat, :lng, :location_name, :location_image, :done, :nominee_attributes => [ :full_name, :email, :phone, :user_id, :twitter_id, :facebook_id ], :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params

  private
    def apply_scopes(target)
      if params[:done].present?
        target = target.done(params[:done])
      end
      if params[:category_id].present?
        target = target.in_category(params[:category_id])
      end

      target
    end
end

