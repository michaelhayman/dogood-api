class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  # force_ssl

  before_filter :check_auth, unless: :exceptions_met?
  respond_to :json

  def check_auth
    authenticate_or_request_with_http_basic do |email, password|
      resource = User.find_by_email(email)
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

  def exceptions_met?
    (params[:controller] == "users" && params[:action] == "status") ||
    devise_controller?
  end
end
