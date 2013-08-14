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

  def likers
    @instance = params[:type].
      constantize.
      find(params[:id])
    respond_with @instance.votes.map(&:voter), root: "user"
  end

  def followers
    @instance = params[:type].
      constantize.
      find(params[:id])
    respond_with @instance.followers, root: "user"
  end

  def following
    @instance = params[:type].
      constantize.
      find(params[:id])
    respond_with @instance.follows_by_type(params[:type]).map(&:followable), root: "user"
  end
end

