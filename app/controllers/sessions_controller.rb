# encoding: UTF-8

class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    warden.custom_failure!
    logger.debug "hey what happened #{params[:user][:email]}"
    user = User.find_for_database_authentication(params[:user])
    return invalid_login_attempt unless valid_login_attempt?(user)

    sign_in(:user, user)
    render :json => user
  end

  protected

    def ensure_params_exist
      return unless params[:user].blank?
      render :json => {
        :errors => {
          :messages => [ "Missing username or email address." ]
        }
      }, :status => :unauthorized
    end

    def invalid_login_attempt
      purge_current_user

      render :json => {
        :errors => {
          :messages => [ "Invalid username, email or password." ]
        }
      }, :status => :unauthorized
    end

  private

    def valid_login_attempt?(user)
      logger.debug user
      user && user.valid_password?(params[:user][:password])
    end

    def purge_current_user
      if user_signed_in?
        sign_out(current_user)
      end
    end
end

