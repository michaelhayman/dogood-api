class RewardDecoratorTest < DoGood::TestCase
  def setup
    super

    @reward = FactoryGirl.create(:reward)
    @reward = RewardDecorator.decorate(@reward)
  end
end

