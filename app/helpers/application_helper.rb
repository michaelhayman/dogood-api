module ApplicationHelper
  def devise_edit_user_password_url(user)
    "http://0.0.0.0:8001/#/passwords/edit/#{user.reset_password_token}"
  end
end
