class UsersController < ApiController
  include ActionView::Helpers::DateHelper

  before_filter :setup_pagination, only: [
    :search_by_emails,
    :search,
    :search_by_twitter_ids,
    :search_by_facebook_ids,
    :voters,
    :followers,
    :following,
    :nominations_for,
    :followed_by,
    :voted_by,
    :nominations_by,
    :help_wanted_by
  ]

  before_filter :set_selected

  def set_selected
    @profile_selected = "selected"
  end

  def show
    @user = User.friendly.find(params[:id]).decorate

    respond_to do |format|
      format.html
      format.json {
        render json: @user, root: "users", serializer: Users::ProfileSerializer
      }
    end
  end

  def search
    user = User.arel_table
    if (params[:search] != "(null)")
      @users = User.
        where(user[:full_name].
        matches("%#{params[:search]}%")).
        limit(20)
      render_paginated_index(@users, Users::SearchSerializer)
    end
  end

  def search_by_emails
    check_auth
    raise DoGood::Api::ParametersInvalid.new if !params[:emails].present?

    if current_user.email.present?
      params[:emails].delete(current_user.email)
    end

    @users = User.where(email: params[:emails]).limit(20)
    render_paginated_index(@users, Users::SearchSerializer)
  end

  def search_by_twitter_ids
    raise DoGood::Api::ParametersInvalid.new if !params[:twitter_ids].present?

    @users = User.where(twitter_id: params[:twitter_ids]).limit(50)
    render_paginated_index(@users, Users::SearchSerializer)
  end

  def search_by_facebook_ids
    raise DoGood::Api::ParametersInvalid.new if !params[:facebook_ids].present?
    @users = User.where(facebook_id: params[:facebook_ids]).limit(50)
    render_paginated_index(@users, Users::SearchSerializer)
  end

  def voters
    @instance = params[:type].
      constantize.
      find(params[:id])
    @user_ids = @instance.votes_for.up.by_type(User).voters.map(&:id)
    @users = User.where(id: @user_ids)
    render_paginated_index(@users, Users::SearchSerializer)
  end

  def followers
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.user_followers
    respond_to do |format|
      format.html {
        @user = User.find(params[:id]).decorate
        @users = @users.decorate
      }
      format.json {
        render_paginated_index(@users, Users::SearchSerializer)
      }
    end
  end

  def following
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.following_users
    respond_to do |format|
      format.html {
        @user = User.find(params[:id]).decorate
        @users = @users.decorate
      }
      format.json {
        render_paginated_index(@users, Users::SearchSerializer)
      }
    end
  end

  def nominations_for
    @user = User.friendly.find(params[:id]).decorate
    @goods = Good.
      newest_first.
      nominations_for_user(@user.id).
      extra_info

    respond_to do |format|
      format.html {
        @goods = @goods.decorate
      }
      format.json {
        render_paginated_index(@goods, nil, "goods")
      }
    end
  end

  def followed_by
    @user = User.friendly.find(params[:id]).decorate
    @goods = Good.
      extra_info.
      newest_first.
      followed_by_user(@user.id)

    respond_to do |format|
      format.html {
        @goods = @goods.decorate
      }
      format.json {
        render_paginated_index(@goods, nil, "goods")
      }
    end
  end

  def voted_by
    @user = User.friendly.find(params[:id]).decorate
    @goods = Good.
      extra_info.
      newest_first.
      voted_by_user(@user.id)

    respond_to do |format|
      format.html {
        @goods = @goods.decorate
      }
      format.json {
        render_paginated_index(@goods, nil, "goods")
      }
    end
  end

  def nominations_by
    @user = User.friendly.find(params[:id]).decorate
    @goods = Good.
      newest_first.
      nominations_by_user(@user.id).
      extra_info

    respond_to do |format|
      format.html {
        @goods = @goods.decorate
      }
      format.json {
        render_paginated_index(@goods, nil, "goods")
      }
    end
  end

  def help_wanted_by
    @user = User.friendly.find(params[:id]).decorate
    @goods = Good.
      newest_first.
      help_wanted_by_user(@user.id).
      extra_info

    respond_to do |format|
      format.html {
        @goods = @goods.decorate
      }
      format.json {
        render_paginated_index(@goods, nil, "goods")
      }
    end
  end

  def rank
    @users = User.find(params[:id])

    render json: { rank: @users.rank }
  end

  def update_profile
    check_auth

    if current_user.update(profile_params)
      @user = current_user
      render json: @user.decorate, root: "users"
    else
      message = "Unable to update your details."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def update_password
    check_auth
    if current_user.update_password(password_params)
      @user = current_user
      render json: @user.decorate, root: "users"
    else
      message = "Unable to update your password."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def social
    check_auth

    if current_user.update_attributes(social_params)
      @user = current_user
      render json: @user.decorate, root: "users"
    else
      message = "Couldn't save the social ID."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def remove_avatar
    check_auth

    current_user.remove_avatar!

    if current_user.save
      @user = current_user
      render json: @user.decorate, root: "users"
    else
      message = "Unable to delete your photo."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def points
    if current_user
      render json: dg_user.decorate, root: "users", serializer: Users::CurrentUserSerializer
    else
      render_error(DoGood::Api::Unauthorized.new)
    end
  end

  # html methods
  # def status
  #   @user = User.find_by_id(params[:id])
  #   respond_to do |format|
  #     format.html {
  #       if @user.present?
  #         render :status
  #       else
  #         render :status_not_found
  #       end
  #     }
  #   end
  # end

  def validate_name
    @user = User.new(profile_params)

    if @user.valid_name?
      render json: @user.decorate, root: "users"
    else
      error = @user.errors[:full_name]
      render_error(DoGood::Api::ParametersInvalid.new(error))
    end
  end

  def profile_params
    params.require(:user).permit(:full_name, :biography, :location, :phone, :avatar)
  end
  private :profile_params

  def social_params
    params.require(:user).permit(:twitter_id, :facebook_id)
  end
  private :profile_params

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  private :password_params
end

