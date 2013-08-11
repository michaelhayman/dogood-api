# encoding: UTF-8

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new(resource_params)

    if user.save
      sign_in(:user, user)
      render :json => user
      return
    else
      if user.errors.any?
        messages = user.errors.full_messages
      else
        messages = [ "There were errors.  Please try again." ]
      end
      # logger.debug "failed #{messages}"

      render :json => {
        :errors => {
          :messages => [ messages.first ]
        }
      }, :status => :unprocessable_entity
    end
  end

  def update
    if @user.update_attributes(
      :first_name => params[:user][:first_name],
      :last_name => params[:user][:last_name],
      :contactable => params[:user][:contactable])

      render :json => @user
      return
    end

    render :json => {
      :errors => {
        :messages => [ "Unable to update your details." ]
      }
    }, :status => :unprocessable_entity
  end

  def resource_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
  private :resource_params

end

