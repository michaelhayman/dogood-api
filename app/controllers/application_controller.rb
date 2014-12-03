class ApplicationController < ActionController::Base
  include CurrentUserHelper

  serialization_scope :dg_user

  respond_to :json, :html

  def instance_from_type_and_id(type, id)
    type.constantize.find(id)
  end

  rescue_from DoGood::Api::Unauthorized do |exception|
    render_error(exception)
  end

  rescue_from DoGood::Api::Error do |exception|
    render_error(exception)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render_error(DoGood::Api::ParametersInvalid.new(exception.message))
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_error(DoGood::Api::ParametersInvalid.new(exception.message))
  end

  rescue_from DoGood::Api::ParametersInvalid do |exception|
    render_error(exception)
  end

  rescue_from DoGood::Api::RecordNotSaved do |exception|
    render_error(exception)
  end

  rescue_from DoGood::Api::TooManyQueries do |exception|
    render_error(exception)
  end

  private
    def set_default_response_format
      request.format = :html
    end

    def check_auth
      raise DoGood::Api::Unauthorized.new if !logged_in?
    end
end
