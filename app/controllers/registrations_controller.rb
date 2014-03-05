class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  include Api::Helpers::RenderHelper

  before_filter :check_auth, :only => [ :update ]

  def create
    user = User.new(resource_params)
    user.avatar = params[:user][:avatar]

    if user.save
      sign_in(:user, user)
      @user = UserDecorator.decorate(user)
      render_success('users/show')
      return
    else
      if user.errors.any?
        messages = user.errors.full_messages
      else
        messages = [ "There were errors.  Please try again." ]
      end
      raise DoGood::Api::Unprocessable.new(messages.first)
    end
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :phone, :avatar)
  end
  private :resource_params

end

