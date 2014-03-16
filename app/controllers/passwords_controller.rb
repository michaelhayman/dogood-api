class PasswordsController < Devise::PasswordsController
  respond_to :json
  include Api::Helpers::RenderHelper

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      @user = self.resource
      @user.message = "A message has been sent to reset your password.  Please check your inbox."
      render json: @user, root: "users", serializer: Users::CurrentUserSerializer
    else
      raise DoGood::Api::ParametersInvalid.new("Invalid email address.")
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(reset_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      sign_in(resource_name, resource)
      render json: { message: flash_message }
    else
      msg = resource.errors.full_messages.first || "Invalid token.  Try resetting your password again."
      raise DoGood::Api::ParametersInvalid.new(msg)
    end
  end

  def reset_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end
  private :reset_params
end

