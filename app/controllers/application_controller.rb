class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # protect_from_forgery with: :null_session

  before_filter :check_auth
  respond_to :json

  def check_auth
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_email(username)
      if resource && resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end

end