# need to refresh the points

class RewardsController < ApplicationController
  def index
    # includes(:user => :sponsor)
    @rewards = Reward.available.includes(:user).load
    respond_with @rewards
  end

  def highlights
    @rewards = Reward.available.sufficient_points(current_user).includes(:user).load
    respond_with @rewards
  end

  def claimed
    @rewards = current_user.
      rewards.
      order('claimed_rewards.created_at DESC')
    respond_with @rewards
  end

  def create
    @reward = Reward.new(
      :name => resource_params[:name],
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
    @claimed_reward = ClaimedReward.new(
      :reward_id => resource_params[:id],
      :user_id => current_user.id)

    if @claimed_reward.reward.cost > current_user.points
      render_errors("Insufficient points.")
      return
    end

    @reward = Reward.available.find_by_id(resource_params[:id])
    if !@reward
      render_errors("Reward not longer available.")
      return
    end

    # insert logic to wait a bit before claiming another reward

    if @claimed_reward.save
      @claimed_reward.withdraw_points
      # current_user.increment!(:points, - @claimed_reward.reward.cost)
      respond_with @claimed_reward.reward, root: "rewards"
    else
      render_errors("Couldn't claim the reward.")
    end
  end

  def resource_params
    params.require(:reward).permit(:id, :name)
  end
  private :resource_params
end

