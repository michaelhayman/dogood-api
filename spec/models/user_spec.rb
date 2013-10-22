require 'spec_helper'

describe User do
  context "has validations" do
    it "should be valid with all default values" do
      FactoryGirl.build(:user).should be_valid
    end

    it "should have an email address" do
      FactoryGirl.build(:user, email: "").should_not be_valid
    end

    it "should have a password" do
      FactoryGirl.build(:user, password: "").should_not be_valid
    end
  end

  it "should return a specific user" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, :email => Faker::Internet.email)
    User.by_id(user1.id).should == user1
  end

  context "points" do
    # not implemented
    pending "it should return a user's score" do
    end

    it "should return a user's rank" do
      user = FactoryGirl.create(:user)
      point = FactoryGirl.create(
        :point,
        :to_user_id => user.id)

      user.rank.should == "B"
    end

    it "it should return a user's points" do
      user = FactoryGirl.create(:user)
      point = FactoryGirl.create(
        :point,
        :to_user_id => user.id)

      user.points.should == 5000
    end
  end

end

