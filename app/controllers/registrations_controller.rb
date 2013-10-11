class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_filter :check_auth, :only => [ :update ]

  def create
    user = User.new(resource_params)
    user.avatar = params[:user][:avatar]

    if user.save
      sign_in(:user, user)
      render :json => user, serializer: CurrentUserSerializer, root: "user"

      return
    else
      if user.errors.any?
        messages = user.errors.full_messages
      else
        messages = [ "There were errors.  Please try again." ]
      end
      render_errors(messages.first)
    end
  end

  def resource_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :full_name, :phone)
  end
  private :resource_params

end

