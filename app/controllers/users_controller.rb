class UsersController < ApplicationController
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
      @users = User.where(user[:full_name].matches("%#{params[:search]}%"))
    else
      @users = User.all
    end
    respond_with @users, root: "user"
  end


  def search_by_emails
    @users = User.where(:email => params[:emails])
    respond_with @users, root: "user"
  end

  def search_by_twitter_ids
    @twitter_users = User.where(:twitter_id => params[:twitter_ids])
    # @already_following = Follow.
    #   following("User", current_user.id).map(&:twitter_id)
    # @twitter_users.each

    respond_with @twitter_users, root: "user"
  end

  def search_by_facebook_ids
    if (params[:facebook_ids] != nil)
      @facebook_users = User.where(:facebook_id => params[:facebook_ids])
    else
      @facebook_users = nil
    end

    respond_with @facebook_users, root: "user"
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
    @likers = @instance.votes.map(&:voter)
    respond_with @likers, root: "user"
  end

  def followers
    @instance = params[:type].
      constantize.
      find(params[:id])
    @followers = @instance.followers
    respond_with @followers, root: "user"
  end

  def following
    @instance = params[:type].
      constantize.
      find(params[:id])
    @following = @instance.follows_by_type(params[:type]).map(&:followable)
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

  def profile_params
    params.require(:user).permit(:full_name, :biography, :location, :phone, :avatar)
  end
  private :profile_params

  def social_params
    params.require(:user).permit(:twitter_id, :facebook_id)
  end
  private :profile_params
end

