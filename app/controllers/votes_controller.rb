class VotesController < ApplicationController
  before_filter :polymorphic_association, :only => [:create, :remove]

  def create
    if polymorphic_association.liked_by current_user
      render_ok(resource_params[:voteable_id])
    else
      render_errors("Like not registered.")
    end
  end

  def remove
    if polymorphic_association.unliked_by :voter => current_user
      render_ok(resource_params[:voteable_id])
    else
      render_errors("Unlike not registered.")
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

    def render_ok(id)
      render :json => {
        :votes => {
          :voteable_id => id
        }
      }, :status => :ok
    end
end

