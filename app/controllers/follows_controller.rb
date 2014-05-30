class FollowsController < ApiController
  before_filter :check_auth

  def create
    raise DoGood::Api::ParametersInvalid.new("Already following that.") if current_user.following?(polymorphic_association)

    if current_user.follow(polymorphic_association)
      render_ok
    else
      raise DoGood::Api::RecordNotSaved.new("Follow not registered.")
    end
  end

  def destroy
    if current_user.stop_following polymorphic_association
      render_ok
    else
      raise DoGood::Api::RecordNotSaved.new("Unfollow not registered.")
    end
  end

  def resource_params
    params.require(:follow).permit(:followable_id, :followable_type)
  end
  private :resource_params

  private
    def polymorphic_association
      resource_params[:followable_type].
        constantize.
        where(id: resource_params[:followable_id]).
        first
    end
end

