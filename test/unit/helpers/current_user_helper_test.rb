module CurrentUserHelperTests
  module Base
    include CurrentUserHelper

    def session
      "hi"
    end
  end

  class TestUser < DoGood::ActionViewTestCase
    include Base

    def current_user
      FactoryGirl.create(:user)
    end

    def user_signed_in?
      true
    end

    test "should be a user type class" do
      assert_equal dg_user.object.class, User
    end

    test "should be logged in" do
      assert logged_in?
    end
  end

  class TestNullUser < DoGood::ActionViewTestCase
    include Base

    def current_user
      NullUser.new
    end

    def user_signed_in?
      false
    end

    test "should be a decorated null (guest) user object" do
      assert_equal dg_user.object.class, NullUser
    end

    test "shouldn't be logged in" do
      refute logged_in?
    end
  end
end
