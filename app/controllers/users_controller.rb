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
    render_success('show')
  end

  def search
    user = User.arel_table
    if (params[:search] != "(null)")
      @users = User.where(user[:full_name].matches("%#{params[:search]}%")).limit(20)
    else
      @users = User.all
    end
    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def search_by_emails
    if params[:emails]
      if current_user
        params[:emails].delete(current_user.email)
      end
    end

    @users = User.where(:email => params[:emails]).limit(20)

    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def search_by_twitter_ids
    @users = User.where(:twitter_id => params[:twitter_ids]).limit(50)
    # @already_following = Follow.
    #   following("User", current_user.id).map(&:twitter_id)
    # @twitter_users.each

    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def search_by_facebook_ids
    if (params[:facebook_ids] != nil)
      @users = User.where(:facebook_id => params[:facebook_ids]).limit(50)
    else
      @users = nil
    end

    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def likers
    @instance = params[:type].
      constantize.
      find(params[:id])
    @users = @instance.votes.up.by_type(User).voters
    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def followers
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.followers_scoped.
      limit(20).
      map(&:follower)
    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def following
    @instance = instance_from_type_and_id(params[:type], params[:id])
    @users = @instance.follows_by_type(params[:type]).
      limit(20).
      map(&:followable)
    @users = @users.paginate(@pagination_options)
    render_success('index')
  end

  def score
    if params[:id]
      user = User.find(params[:id])
    else
      user = current_user
    end

    render :json => user.score
  end

  def update_profile
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?

      if current_user.update!(profile_params)
        @user = current_user
        render_success('show')
      else
        message = "Unable to update your details."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::Unauthorized => error
      render_error(error)
      return
    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  def update_password
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?

      if current_user.update_password(password_params)
        @user = current_user
        render_success('show')
      else
        message = "Unable to update your password."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::Unauthorized => error
      render_error(error)
      return
    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  def social
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?

      if current_user.update_attributes(social_params)
        @user = current_user
        render_success('show')
      else
        message = "Couldn't save the social ID."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::Unauthorized => error
      render_error(error)
      return
    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  def remove_avatar
    current_user.remove_avatar!

    if current_user.save
      render :json => current_user
      return
    end
    render_errors("Unable to delete your photo.")
  end

  def points
    render :json => {
      :user => {
        :points => current_user.points
      }
    }
  end

  # html methods
  def status
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html {
        if @user.present?
          render :status
        else
          render :status_not_found
        end
      }
    end
  end

  def validate_name
    user = User.new(profile_params)

    if user.valid_name?
      render :json => {
        :user => user, serializer: CurrentUserSerializer
      }
    else
      render_errors(user.errors[:full_name])
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

