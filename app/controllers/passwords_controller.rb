class PasswordsController < Devise::PasswordsController
  respond_to :json
  include Api::Helpers::RenderHelper

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :json => dapi_callback_wrapper_new_style(status: :ok) { |json|
        json.users do
          json.message "A message has been sent to reset your password.  Please check your inbox."
        end
      }
    else
      raise DoGood::Api::Unprocessable.new("Invalid email address.")
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      render :password_update_successful
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :reset_password_token)
  end
  private :resource_params
end

