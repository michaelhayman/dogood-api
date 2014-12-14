class GoodsController < ApiController
  include DecoratorHelper

  before_filter :setup_pagination, only: [
    :index,
    :show,
    :tagged,
    :popular,
    :nearby
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
    # if params missing hash, add it
    if params[:name].present?
      params[:name] = "#" + params[:name] unless params[:name].include?("#")
    end

    hashtagged_elements = Tag.link_ids_matching_name(params[:name])

    @goods = Good.where(id: hashtagged_elements).
      extra_info.
      newest_first

    @goods = apply_scopes(@goods)

    respond_to do |format|
      format.html {
        @goods = paginated_entries(@goods)
      }
      format.json {
        render_paginated_index(@goods)
      }
    end
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
    redirect_to "/users/#{params[:user_id]}/nominations_for", status: :moved_permanently
  end

  def followed_by
    redirect_to "/users/#{params[:user_id]}/followed_by", status: :moved_permanently
  end

  def voted_by
    redirect_to "/users/#{params[:user_id]}/voted_by", status: :moved_permanently
  end

  def nominations_by
    redirect_to "/users/#{params[:user_id]}/nominations_by", status: :moved_permanently
  end

  def help_wanted_by
    redirect_to "/users/#{params[:user_id]}/help_wanted_by", status: :moved_permanently
  end

  def new
    @good = Good.new
    @good.build_nominee
  end

  def edit
    @good = Good.find(params[:id])
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

