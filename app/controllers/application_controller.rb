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
  before_filter :set_default_response_format

  def instance_from_type_and_id(type, id)
    type.constantize.find(id)
  end

  private
    def set_default_response_format
      request.format = :json
    end
end
