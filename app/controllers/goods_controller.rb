class GoodsController < ApiController
  include DecoratorHelper

  before_filter :setup_pagination, only: [
    :index,
    :show,
    :tagged,
    :popular,
    :nearby,
    :nominations_for,
    :followed_by,
    :voted_by,
    :nominations_by,
    :help_wanted_by
  ]

  def index
    @goods = apply_scopes(Good.extra_info)

    respond_to do |format|
      format.html {
        @goods = paginated_entries(@goods)
      }
      format.json {
        render_paginated_index(@goods)
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        @good = Good.friendly.where(slug: params[:id]).first.decorate
      }
      format.json {
        @good = Good.friendly.where(id: params[:id])
        render_paginated_index(@good)
      }
    end
  end

  def tagged
    hashtagged_elements = Tag.link_ids_matching_name(params[:name])

    @goods = Good.where(id: hashtagged_elements).
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

  def voted_by
    @goods = apply_scopes(Good.
      newest_first.
      voted_by_user(params[:user_id]))

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

  def new
    @good = Good.new
  end

  def create
    check_auth
    raise DoGood::Api::TooManyQueries.new if Good.just_created_by(dg_user)
    raise DoGood::Api::ParametersInvalid.new("No parameters.") unless params[:good].present?

    @good = Good.new(resource_params)
    @good.user_id = current_user.id
    @good.evidence = resource_params[:evidence]

    if @good.save
      @good.send_notification
      @good.entities.each do |e|
        e.send_notification
      end

      render json: @good.decorate, root: "goods"
      if @good.send_invite?
        InviteMailer.invite_nominee(@good).deliver
      end
    else
      message = @good.errors.full_messages.first || "Couldn't save good."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def destroy
    check_auth
    @good = Good.find(params[:id])

    raise DoGood::Api::ParametersInvalid.new("That is not your post.") if @good.user_id != current_user.id

    if @good.destroy
      render_ok
    else
      message = @good.errors.full_messages.first || "Couldn't delete good."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def resource_params
    params.require(:good).permit(
      :caption,
      :evidence,
      :user_id,
      :category_id,
      :lat,
      :lng,
      :location_name,
      :location_image,
      :done,
      nominee_attributes: [
        :full_name,
        :email,
        :phone,
        :user_id,
        :twitter_id,
        :facebook_id,
        :avatar,
        :invite
      ],
      entities_attributes: [
        :link_id,
        :link_type,
        :title,
        range: []
    ])
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

