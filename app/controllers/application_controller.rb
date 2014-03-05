class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  # force_ssl
  include CurrentUserHelper

  serialization_scope :dg_user

  respond_to :json
  before_filter :set_default_response_format

  def instance_from_type_and_id(type, id)
    type.constantize.find(id)
  end

  rescue_from DoGood::Api::Unprocessable do |exception|
    render_error(exception)
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_error(DoGood::Api::Unprocessable.new(exception.message))
  end

  rescue_from DoGood::Api::Unauthorized do |exception|
    render_error(exception)
  end

  rescue_from DoGood::Api::ParametersInvalid do |exception|
    render_error(exception)
  end

  rescue_from DoGood::Api::RecordNotSaved do |exception|
    render_error(exception)
  end

  private
    def set_default_response_format
      request.format = :json
    end
end
