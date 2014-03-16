class RewardsController < ApiController
  before_filter :setup_pagination, :only => [
    :claimed,
    :index,
    :highlights
  ]
  before_filter :check_auth, :only => [
    :claim,
    :claimed,
    :create,
    :highlights
  ]

  def index
    @rewards = Reward.available.includes(:user)
    render_paginated_index(@rewards)
  end

  def highlights
    @rewards = Reward.available.
      sufficient_points(current_user).
      includes(:user)
    render_paginated_index(@rewards)
  end

  def claimed
    @rewards = current_user.
      rewards.
      order('claimed_rewards.created_at DESC')
    render_paginated_index(@rewards)
  end

  def create
    @reward = Reward.new(
      :title => resource_params[:title],
      :subtitle => resource_params[:subtitle],
      :user_id => current_user.id)

    if @reward.save
      render json: @reward, root: "rewards"
    else
      msg = @reward.errors.full_messages.first || "Couldn't add the reward."
      raise DoGood::Api::RecordNotSaved.new(msg)
    end
  end

  def destroy
  end

  def claim
    raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:reward].present?
    raise DoGood::Api::TooManyQueries.new if Reward.just_created_by(dg_user)

    @claimed_reward = ClaimedReward.new(
      :reward_id => resource_params[:id],
      :user_id => current_user.id)

    raise DoGood::Api::RecordNotSaved.new("Invalid reward.") if !@claimed_reward.reward
    raise DoGood::Api::RecordNotSaved.new("Insufficient points.") if !@claimed_reward.within_budget?(current_user.points)

    @reward = Reward.available.find_by_id(resource_params[:id])

    raise DoGood::Api::RecordNotSaved.new("Reward no longer available.") unless @reward

    if @claimed_reward.save
      @claimed_reward.withdraw_points
      render json: @claimed_reward.reward, root: "rewards"
    else
      raise DoGood::Api::RecordNotSaved.new("Couldn't claim reward.")
    end
  end

  def resource_params
    params.require(:reward).permit(:id, :title, :subtitle)
  end
  private :resource_params
end

