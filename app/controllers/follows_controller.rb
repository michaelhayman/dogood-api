# add_column :goods, :followers, :integer, :default => 0
# increment_counter :goods, :followers
# decrement_counter :goods, :followers

class FollowsController < ApplicationController
  before_filter :polymorphic_association, :only => [:create, :remove]

  def create
    if current_user.follow polymorphic_association
      render_ok(resource_params[:followable_id])
      # polymorphic_associationk0
    else
      render_error("Follow registered.")
    end
  end

  def remove
    if current_user.stop_following polymorphic_association
      render_ok(resource_params[:followable_id])
    else
      render_error("Follow not registered.")
    end
  end

  def resource_params
    params.require(:follow).permit(:followable_id, :followable_type, :user_id)
  end
  private :resource_params

  private
    def polymorphic_association
      resource_params[:followable_type].
        constantize.
        where(:id => resource_params[:followable_id]).
        first
    end

    def render_ok(id)
      render :json => {
        :follows => {
          :followable_id => id
        }
      }, :status => :ok
    end
end

