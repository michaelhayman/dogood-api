class RewardSerializerTest < DoGood::TestCase
  def expected_hash
    {
      rewards: {
        id: @reward.id,
        title: @reward.title,
        subtitle: @reward.subtitle,
        teaser: @reward.teaser,
        full_description: @reward.full_description,
        cost: @reward.cost,
        quantity: @reward.quantity,
        quantity_remaining: @reward.quantity_remaining,
        instructions: @reward.instructions,
        within_budget: @reward.within_budget,
        user: {
          id: @reward.user.id,
          avatar_url: @reward.user.avatar_url,
          full_name: @reward.user.full_name
        }
      }
    }
  end

  def setup
    super
    @reward = FactoryGirl.create(:reward).decorate
    stub(@reward.helpers).logged_in? { true }
    stub(@reward.helpers).dg_user { FactoryGirl.build(:user) }

    @serializer = RewardSerializer.new @reward, root: "rewards"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

