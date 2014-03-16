module ApplicationHelper
  def devise_edit_user_password_url(token)
    "http://0.0.0.0:8001/#/passwords/edit/#{token}"
  end
end
