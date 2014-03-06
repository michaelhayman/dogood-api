class PasswordsController < Devise::PasswordsController
  respond_to :json
  include Api::Helpers::RenderHelper

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      @user = self.resource
      @user.message = "A message has been sent to reset your password.  Please check your inbox."
      render json: @user, root: "users"
    else
      raise DoGood::Api::ParametersInvalid.new("Invalid email address.")
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      render :password_update_successful
    else
      render :edit
      raise DoGood::Api::ParametersInvalid.new("Invalid email address.")
     end
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :reset_password_token)
  end
  private :resource_params
end

