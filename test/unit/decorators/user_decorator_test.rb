require 'test_helper'

class UserDecoratorTest < DoGood::TestCase
  def expected_hash
    user = @user.object
    {
      "id" => user.id,
      "full_name" => user.full_name,
      "email" => user.email
    }
  end

  def setup
    super

    @user = FactoryGirl.create(:user)
    @user = UserDecorator.decorate(@user)
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@user.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

