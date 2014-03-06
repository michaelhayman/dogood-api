class VotesController < ApiController
  VOTE_POINTS = 10

  before_filter :check_auth

  def create
    begin
      raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:vote].present?
      raise DoGood::Api::RecordNotSaved.new("You can't vote on your own record.") if own_record?

      if polymorphic_association.liked_by current_user
        render_ok
        Point.record_points(resource_params[:voteable_type], resource_params[:voteable_id], "Like", polymorphic_association.user_id, current_user.id, VOTE_POINTS)
      else
        raise DoGood::Api::RecordNotSaved.new("Like not registered.")
      end
    end
  end

  def remove
    if polymorphic_association.unliked_by :voter => current_user
      render_ok
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

end

