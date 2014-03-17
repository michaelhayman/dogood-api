require 'test_helper'

class UserTest < DoGood::TestCase
  def setup
    super
    @user = FactoryGirl.create(:user)
  end

  context "validations" do
    test "has a valid name" do
      assert @user.valid?, "Should be valid"
    end
  end

  context "has validations" do
    test "should be valid with all default values" do
      assert FactoryGirl.build(:user).valid?
    end

    test "should have an email address" do
      assert FactoryGirl.build(:user).valid?
      refute FactoryGirl.build(:user, email: "").valid?
    end

    test "should have a password" do
      assert FactoryGirl.build(:user).valid?
      refute FactoryGirl.build(:user, password: "").valid?
    end
  end

  test "should return a specific user" do
    user2 = FactoryGirl.create(:user, :email => Faker::Internet.email)
    assert_equal @user, User.by_id(@user.id)
  end

  context "points" do
    test "test should return a user's rank" do
      assert_equal "E", @user.rank
    end

    test "it should return a user's points" do
      points = 5000
      @user.add_points(points, category: 'Bonus')
      assert_equal points, @user.points
    end
  end

  context "update password" do
    def setup
      super
      @password = HashWithIndifferentAccess.new({
        current_password: @user.password,
        password: "oh_billy",
        password_confirmation: "oh_billy"
      })
    end

    test "no errors returned if the params are valid" do
      @user.update_password(@password)

      assert @user.errors.count == 0
    end

    test "errors with missing params" do
      @bad_password = HashWithIndifferentAccess.new({
        current_password: "",
        password: "",
        password_confirmation: ""
      })
      @user.update_password(@bad_password)
      assert @user.errors.count > 0
    end
  end
end
