require 'test_helper'

class GoodTest < DoGood::TestCase
  include DoGood::ContextHelper

  context "scopes" do
    test "should return the standard goods" do
      21.times do
        FactoryGirl.create(:good)
      end

      assert_equal 20, Good.standard.count
    end
  end

  context "has validations" do
    def setup
      super
    end

    test "should have a caption" do
      assert FactoryGirl.build(:good).valid?
    end

    test "should not have a caption that is too long" do
      refute FactoryGirl.build(:good, :long_caption).valid?
    end

    test "should be associated with a user" do
      refute FactoryGirl.build(:good, :no_user).valid?
    end
  end

 test "should add points" do

 end

  context "queries" do
    test "should return only goods belonging to a category" do
      good1 = FactoryGirl.create(:good, :category_id => 3)
      good2 = FactoryGirl.create(:good, :category_id => 5)
      assert_equal 1, Good.in_category(5).count
    end

    test "nearby should contain only " do
      good = FactoryGirl.create(:good)
      sydney_good = FactoryGirl.create(:good, :sydney)
      assert_equal 1, Good.nearby(good[:lat], good[:lng]).count
    end

    test "should return goods by a specific user" do
      good1 = FactoryGirl.create(:good, :user_id => 3)
      good2 = FactoryGirl.create(:good, :user_id => 5)
      assert_equal 1, Good.by_user(5).count
    end

    test "should return only goods liked by a user" do
      user = FactoryGirl.create(:user)
      good1 = FactoryGirl.create(:good)
      good1.liked_by user
      good2 = FactoryGirl.create(:good, :bob)
      assert_equal 1, Good.liked_by_user(user.id).count
    end

    test "should return goods posted or followed by a user" do
    end

    test "should return a specific good" do
      good1 = FactoryGirl.create(:good)
      good2 = FactoryGirl.create(:good)
      assert_equal 1, Good.specific(good2.id).count
    end
  end

  test "should return the most relevant goods" do
    11.times do
      FactoryGirl.create(:good)
    end

    assert_equal 10, Good.most_relevant.count
  end


  test "should block posting for a user who just created a good" do
    FactoryGirl.create(:good, :user_id => 11)
    assert_equal 1, Good.just_created_by(11).count
  end

 # pending "should return extra info" do
 # end

 # pending "should include user details when there's goods and a user" do
 # end
end
