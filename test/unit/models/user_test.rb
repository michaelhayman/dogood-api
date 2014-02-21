require 'test_helper'

class UserTest < DoGood::TestCase
  context "validations" do
    test "has a valid name" do
      user = FactoryGirl.create(:user)
      assert user.valid?, "Should be valid"
    end
  end
end
