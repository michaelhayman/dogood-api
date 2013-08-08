class UsersController < ApplicationController
  def index
    authenticate_user!
    @users = User.all
    respond_with @users
  end
end

