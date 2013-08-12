class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # protect_from_forgery with: :null_session
  # force_ssl

  before_filter :check_auth, unless: :devise_controller?
  # before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_filter :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  def check_auth
    authenticate_or_request_with_http_basic do |username, password|
      logger.debug username
      logger.debug password
      resource = User.find_by_username(username)
      if resource && resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end

  def render_errors(messages, status = :unprocessable_entity)
    messages = Array.wrap(messages)
    render :json => {
      :errors => {
        :messages => messages
      }
    }, :status => status
  end

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) << :username
  # end

  # def configure_permitted_parameters
  #   logger.debug "hit #{devise_parameter_sanitizer.inspect}"
  #   devise_parameter_sanitizer.for(:sign_in) { |u|
  #     u.permit(:username, :email, :password) }
  #   devise_parameter_sanitizer.for(:sign_up) { |u|
  #     u.permit(:username, :email, :password, :password_confirmation) }
  # end
end
