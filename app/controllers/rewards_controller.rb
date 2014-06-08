class RewardsController < ApiController
  before_filter :setup_pagination, only: [
    :claimed,
    :index,
    :highlights
  ]
  before_filter :check_auth, only: [
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
    @reward = Reward.new(resource_params)
    @reward.user_id = current_user.id

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
      reward_id: resource_params[:id],
      user_id: current_user.id)

    if @claimed_reward.create_claim
      render json: @claimed_reward.reward.decorate, root: "rewards"
    else
      msg = @claimed_reward.errors.full_messages || "Couldn't claim reward."
      raise DoGood::Api::RecordNotSaved.new(msg)
    end
  end

  def resource_params
    params.require(:reward).permit(:id, :title, :subtitle, :quantity, :quantity_remaining, :cost)
  end
  private :resource_params
end

