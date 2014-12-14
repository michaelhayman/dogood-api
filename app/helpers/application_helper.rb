module ApplicationHelper
  def ios_app_equivalent_url
    if params[:controller] == "goods"
      if params[:action] == "show"
        "goods/#{params[:id]}"
      elsif params[:action] == "new"
        "goods/new"
      end
    elsif params[:controller] == "users"
      if params[:action] == "show"
        "users/#{params[:id]}"
      end
    end
  end
end
