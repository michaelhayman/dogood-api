module CurrentUserHelper
  extend Memoist

  def dg_user
    @dg_user ||= CurrentUserDecorator.decorate(current_user || NullUser.new(
      id: session[:session_id]
    ))
  end

  def logged_in?
    user_signed_in?
  end
end

