# encoding: UTF-8

class PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    logger.debug resource_params
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :json => {
        :user => {
            :message => "A message has been sent to reset your password.  Please check your inbox."
        }
      }, :status => :ok
    else
      render :json => {
        :errors => {
          :messages => [ "Invalid email address." ]
        }
      }, :status => :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        self.resource = current_user
        # ensure user doesn't leave their new password blank
        params[:user][:password] = params[:user][:current_password] if params[:user][:password].blank? && current_user.valid_password?(params[:user][:current_password])

        if current_user.valid_password?(params[:user][:current_password])
          if (current_user.update_with_password(params[:user]))
            render :json => {
                :user => {
                  :message => "Your password was updated."
              }
            }, :status => :ok
            return
          else
            message = "Update password failed."
          end
        else
          message = "Incorrect current password."
        end

        if current_user.errors.any?
          messages = current_user.errors.full_messages
        else
          messages = [ message ]
        end

        render :json => {
          :errors => {
            :messages => messages
          }
        }, :status => :unprocessable_entity
      }
    end
  end
end

