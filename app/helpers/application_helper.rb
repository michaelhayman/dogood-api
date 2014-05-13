module ApplicationHelper
  def devise_edit_user_password_url(token)
    "http://www.dogood.mobi/#/passwords/edit/#{token}"
  end
end
