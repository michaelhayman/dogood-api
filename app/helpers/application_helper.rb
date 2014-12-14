module ApplicationHelper
  def ios_app_equivalent_url
    if params[:controller] == "goods"
      if params[:action] == "show"
        @good = Good.friendly.find(params[:id])
        "goods/#{@good.id}"
      elsif params[:action] == "new"
        "goods/new"
      end
    elsif params[:controller] == "users"
      if params[:action] == "show"
        @user = User.friendly.find(params[:id])
        "users/#{@user.id}"
      end
    end
  end
end
