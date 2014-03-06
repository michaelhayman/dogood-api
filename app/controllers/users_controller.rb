class UsersController < ApiController
  include ActionView::Helpers::DateHelper

  before_filter :setup_pagination, :only => [
    :search_by_emails,
    :search,
    :search_by_twitter_ids,
    :search_by_facebook_ids,
    :likers,
    :followers,
    :following
  ]

  def show
    @user = User.find(params[:id])
    render json: @user.decorate, root: "users"
  end

  def search
    user = User.arel_table
    if (params[:search] != "(null)")
      @users = User.
        where(user[:full_name].
        matches("%#{params[:search]}%")).
        limit(20)
    end
    @users = @users.paginate(@pagination_options)
    render json: @users
  end

  def search_by_emails
    begin
      check_auth
      raise DoGood::Api::ParametersInvalid.new if !params[:emails].present?

      if current_user.email.present?
        params[:emails].delete(current_user.email)
      end

      @users = User.where(:email => params[:emails]).limit(20)
      @users = @users.paginate(@pagination_options)

      render json: @users
    end
  end

  def search_by_twitter_ids
    begin
      raise DoGood::Api::ParametersInvalid.new if !params[:twitter_ids].present?

      @users = User.where(:twitter_id => params[:twitter_ids]).limit(50)

      @users = @users.paginate(@pagination_options)
      render json: @users
    end
  end

  def search_by_facebook_ids
    begin
      raise DoGood::Api::ParametersInvalid.new if !params[:facebook_ids].present?
      @users = User.where(:facebook_id => params[:facebook_ids]).limit(50)
      @users = @users.paginate(@pagination_options)
      render json: @users
    end
  end

  def likers
    @instance = params[:type].
      constantize.
      find(params[:id])
    @users = @instance.votes.up.by_type(User).voters
    @users = @users.paginate(@pagination_options)
    render json: @users
  end

  def followers
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.followers_scoped.
      limit(20).
      map(&:follower)
    @users = @users.paginate(@pagination_options)
    render json: @users
  end

  def following
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.follows_by_type(params[:type]).
      limit(20).
      map(&:followable)
    @users = @users.paginate(@pagination_options)
    render json: @users
  end

  def score
    @user = User.find(params[:id])

    render json: @user.score
  end

  def update_profile
    begin
      check_auth

      if current_user.update(profile_params)
        @user = current_user
        render json: @user, root: "users"
      else
        message = "Unable to update your details."
        raise DoGood::Api::RecordNotSaved.new(message)
      end
    end
  end

  def update_password
    begin
      check_auth
      if current_user.update_password(password_params)
        @user = current_user
        render json: @user, root: "users"
      else
        message = "Unable to update your password."
        raise DoGood::Api::RecordNotSaved.new(message)
      end
    end
  end

  def social
    begin
      check_auth

      if current_user.update_attributes(social_params)
        @user = current_user
        render json: @user, root: "users"
      else
        message = "Couldn't save the social ID."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    end
  end

  def remove_avatar
    begin
      check_auth

      current_user.remove_avatar!

      if current_user.save
        @user = current_user
        render json: @user, root: "users"
      else
        message = "Unable to delete your photo."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    end
  end

  def points
    if current_user
      render json: dg_user.points
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
      render json: @user, root: "users"
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

