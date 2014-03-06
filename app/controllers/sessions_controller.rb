class SessionsController < Devise::SessionsController
  respond_to :json
  include Api::Helpers::RenderHelper

  def create
    warden.custom_failure!
    ensure_params_exist if !params[:user].present?
    user = User.find_by_email(params[:user][:email])
    invalid_login_attempt unless valid_login_attempt?(user)

    sign_in(:user, user)
    @user = UserDecorator.decorate(user)
    render json: @user, root: "users"
  end

  protected

    def ensure_params_exist
      return unless params[:user].blank?
      raise DoGood::Api::ParametersInvalid.new("Missing email address and password.")
    end

    def invalid_login_attempt
      purge_current_user
      raise DoGood::Api::ParametersInvalid.new("Invalid email or password.")
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

