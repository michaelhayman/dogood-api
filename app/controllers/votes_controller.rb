class VotesController < ApiController
  VOTE_POINTS = 10

  def create
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?
      raise ActionController::ParameterMissing.new("No parameters.") if !params[:vote].present?
      raise DoGood::Api::RecordNotSaved.new("You can't vote on your own record.") if own_record?

      if polymorphic_association.liked_by current_user
        status = D_STATUS[:ok]
        render :json => dapi_callback_wrapper_new_style(:status => status)
        Point.record_points(resource_params[:voteable_type], resource_params[:voteable_id], "Like", polymorphic_association.user_id, current_user.id, VOTE_POINTS)
      else
        raise DoGood::Api::RecordNotSaved.new("Like not registered.")
      end

    rescue ActionController::ParameterMissing => error
      render_error(DoGood::Api::ParametersInvalid.new)
      return
    rescue DoGood::Api::Unauthorized => error
      render_error(error)
      return
    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  # def destroy
  def remove
    if polymorphic_association.unliked_by :voter => current_user
      render_ok(resource_params[:voteable_id])
      Point.remove_points(resource_params[:voteable_type], resource_params[:voteable_id], "Like", polymorphic_association.user_id, current_user.id, VOTE_POINTS)
    else
      render_error(DoGood::Api::RecordNotSaved.new("Unlike not registered."))
    end
  end

  def resource_params
    params.require(:vote).permit(:voteable_id, :voteable_type, :user_id)
  end
  private :resource_params

  private
    def polymorphic_association
      resource_params[:voteable_type].
        constantize.
        where(:id => resource_params[:voteable_id]).
        first
    end

    def own_record?
      polymorphic_association.user == current_user
    end

    def render_ok(id)
      render :json => {
        :votes => {
          :voteable_id => id
        }
      }, :status => :ok
    end
end

