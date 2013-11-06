# encoding: UTF-8

class PasswordsController < Devise::PasswordsController
  # respond_to :json
  layout 'home'

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :json => {
        :user => {
            :message => "A message has been sent to reset your password.  Please check your inbox."
        }
      }, :status => :ok
    else
      render_errors("Invalid email address.")
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

