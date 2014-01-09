class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  # force_ssl

  respond_to :json

  def check_auth
    authenticate_or_request_with_http_basic do |email, password|
      resource = User.find_by_email(email)
      logger.debug "Getting where"
      if resource && resource.valid_password?(password)
        logger.debug "Getting there"
        sign_in :user, resource
      else
        logger.debug "Getting here"
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
