class VotesController < ApiController
  before_filter :check_auth

  def create
    raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:vote].present?

    if @vote = polymorphic_association.liked_by(current_user)
      Vote.send_notification(polymorphic_association, current_user)
      @user = awardable_user
      if awardable_user.present?
        @user.add_points(Vote::VOTE_POINTS, category: 'Vote created')
      end
      render_ok
    else
      raise DoGood::Api::Error.new("Like not registered.")
    end
  end

  def destroy
    if @vote = polymorphic_association.unliked_by(current_user)
      @user = awardable_user
      if awardable_user.present?
        @user.subtract_points(Vote::VOTE_POINTS, category: 'Vote destroyed')
      end
      render_ok
    else
      raise DoGood::Api::Error.new("Unlike not registered.")
    end
  end

  def resource_params
    params.require(:vote).permit(:votable_id, :votable_type)
  end
  private :resource_params

  private
    def polymorphic_association
      resource_params[:votable_type].
        constantize.
        where(id: resource_params[:votable_id]).
        first
    end

    def awardable_user
      if polymorphic_association.done == true
        polymorphic_association.try(:nominee).try(:user)
      end
    end
end
