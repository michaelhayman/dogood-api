class VotesController < ApiController
  before_filter :check_auth

  def create
    raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:vote].present?

    if polymorphic_association.liked_by current_user
      render_ok
    else
      raise DoGood::Api::Error.new("Like not registered.")
    end
  end

  def destroy
    if polymorphic_association.unliked_by :voter => current_user
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
        where(:id => resource_params[:votable_id]).
        first
    end
end
