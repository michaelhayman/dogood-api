# encoding: UTF-8

class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    warden.custom_failure!
    user = User.find_for_database_authentication(params[:user])
    return invalid_login_attempt unless valid_login_attempt?(user)

    sign_in(:user, user)
    render :json => user
  end

  protected

    def ensure_params_exist
      return unless params[:user].blank?
      render_errors("Missing username or email address.", :unauthorized)
    end

    def invalid_login_attempt
      purge_current_user
      render_errors("Invalid username, email or password.", :unauthorized)
    end

  private

    def valid_login_attempt?(user)
      user && user.valid_password?(params[:user][:password])
    end

    def purge_current_user
      if user_signed_in?
        sign_out(current_user)
      end
    end
end

