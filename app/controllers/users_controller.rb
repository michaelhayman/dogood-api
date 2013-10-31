class UsersController < ApplicationController
  include ActionView::Helpers::DateHelper
  # alias :followers, :regooders
  def index
    authenticate_user!
    @users = User.all

    @users.each do |u|
      if u.id == current_user.id
        u.logged_in = true
      else
        u.logged_in = false
      end
    end

    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user, root: "user", serializer: FullUserSerializer
  end

  def update_profile
    if current_user.update_attributes(profile_params)
      render :json => current_user, root: "user", serializer: CurrentUserSerializer
      # render :json => current_user
    else
      render_errors("Unable to update your details.")
    end
  end

  def update_password
    user = current_user

    if user.update_password(password_params)
      render :json => {
        :user => current_user
      }
    else
      render_errors(user.errors.full_messages)
    end
  end

  def social
    if current_user.update_attributes(social_params)
      render :json => current_user
    else
      render_errors("Couldn't save the social ID.")
    end
  end

  def search
    user = User.arel_table
    if (params[:search] != "(null)")
      @users = User.where(user[:full_name].matches("%#{params[:search]}%")).limit(20)
    else
      @users = User.all
    end
    respond_with @users, root: "user"
  end

  def score
    if params[:id]
      user = User.find(params[:id])
    else
      user = current_user
    end

    render :json => user.score
  end

  def search_by_emails
    params[:emails].delete(current_user.email)

    @users = User.where(:email => params[:emails]).limit(20)
    respond_with @users, root: "user"
  end

  def search_by_twitter_ids
    @twitter_users = User.where(:twitter_id => params[:twitter_ids]).limit(50)
    # @already_following = Follow.
    #   following("User", current_user.id).map(&:twitter_id)
    # @twitter_users.each

    respond_with @twitter_users, root: "user"
  end

  def search_by_facebook_ids
    if (params[:facebook_ids] != nil)
      @facebook_users = User.where(:facebook_id => params[:facebook_ids]).limit(50)
    else
      @facebook_users = nil
    end

    respond_with @facebook_users, root: "user"
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

  def likers
    @instance = params[:type].
      constantize.
      find(params[:id])
    @likers = @instance.votes.limit(20).map(&:voter)
    respond_with @likers, root: "user"
  end

  def followers
    @instance = params[:type].
      constantize.
      find(params[:id])
    @followers = @instance.followers_scoped.
      limit(20).
      map(&:follower)
    respond_with @followers, root: "user"
  end

  def following
    @instance = params[:type].
      constantize.
      find(params[:id])
    @following = @instance.follows_by_type(params[:type]).
      limit(20).
      map(&:followable)
    respond_with @following, root: "user"
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

