# need to refresh the points

class RewardsController < ApiController
  before_filter :setup_pagination, :only => [
    :index,
    :highlights,
    :claimed
  ]
  before_filter :check_auth, :only => [
    :claimed,
    :create,
    :highlights
  ]

  def index
    # includes(:user => :sponsor)
    @rewards = Reward.available.includes(:user)
    render_paginated_index(@rewards)
  end

  def highlights
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?
      @rewards = Reward.available.
        sufficient_points(current_user).
        includes(:user)
      render_paginated_index(@rewards)
    end
  end

  def claimed
    begin
      @rewards = current_user.
        rewards.
        order('claimed_rewards.created_at DESC')
      render_paginated_index(@rewards)
    end
  end

  def create
    @reward = Reward.new(
      :title => resource_params[:name],
      :user_id => current_user.id)

    if @reward.save
      respond_with @reward.reward
    else
      render_errors("Couldn't add the reward.")
    end
  end

  def destroy
  end

  def claim
    begin
      # insert logic to wait a bit before claiming another reward

      @claimed_reward = ClaimedReward.new(
        :reward_id => resource_params[:id],
        :user_id => current_user.id)

      if !@claimed_reward.reward
        render_error(DoGood::Api::RecordNotSaved.new("Invalid reward.")) if !@claimed_reward.reward
        return
      end

      if @claimed_reward.reward.cost > current_user.points
        render_error(DoGood::Api::RecordNotSaved.new("Insufficient points."))
        return
      end

      @reward = Reward.available.find_by_id(resource_params[:id])
      if !@reward
        @error = DoGood::Api::RecordNotSaved.new("Reward no longer available.")
        render_error(@error)
        return
      end

      if @claimed_reward.save
        @claimed_reward.withdraw_points
        # current_user.increment!(:points, - @claimed_reward.reward.cost)
        respond_with @claimed_reward.reward, root: "rewards"
      else
        render_error(DoGood::Api::RecordNotSaved.new("Couldn't claim reward."))
      end
    rescue ActionController::ParameterMissing => error
      render_error(DoGood::Api::ParametersInvalid.new)
      return
    end
  end

  def resource_params
    params.require(:reward).permit(:id, :title)
  end
  private :resource_params
end

