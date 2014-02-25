class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  # force_ssl
  include CurrentUserHelper
  include Dapi::CallbackHelper
  include_private Dapi::Constants

  respond_to :json

  def check_auth
    authenticate_or_request_with_http_basic do |email, password|
      resource = User.find_by_email(email)
      if resource && resource.valid_password?(password)
        sign_in :user, resource
      else
        respond_to do |format|
          format.json {
            render_errors("Invalid password.", :unauthorized)
          }
          format.html {
            redirect_to home_path
          }
        end
      end
    end
  end

  def check_auth_silently
    authenticate_or_request_with_http_basic do |email, password|
      resource = User.find_by_email(email)
      if resource && resource.valid_password?(password)
        sign_in :user, resource
      else
        return
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

  def instance_from_type_and_id(type, id)
    type.constantize.find(id)
  end
end
