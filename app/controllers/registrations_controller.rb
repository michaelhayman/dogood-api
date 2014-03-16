class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  include Api::Helpers::RenderHelper

  before_filter :check_auth, :only => [ :update ]

  def create
    @user = User.new(resource_params)
    @user.avatar = params[:user][:avatar]

    if @user.save
      sign_in(:user, @user)
      render json: @user, root: "users", serializer: Users::CurrentUserSerializer
    else
      message = @user.errors.full_messages.first || "There were errors.  Please try again."
      raise DoGood::Api::ParametersInvalid.new(message)
    end
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :phone, :avatar)
  end
  private :resource_params

end

