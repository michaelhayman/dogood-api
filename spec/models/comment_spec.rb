require 'spec_helper'

describe Comment do
  context "has validations" do
    it "should be valid with all default values" do
      FactoryGirl.build(:comment).should be_valid
    end

    it "should have a message" do
      FactoryGirl.build(:comment, :comment => "").should_not be_valid
    end

    it "should not be too long" do
      FactoryGirl.build(:comment, :too_long).should_not be_valid
    end

    it "should have a user" do
      FactoryGirl.build(:comment, user_id: "").should_not be_valid
    end

    it "should not be too short" do
      FactoryGirl.build(:comment, :too_short).should_not be_valid
    end

    context "arrays" do
      it "should return all comments for a specific good" do
        good = FactoryGirl.create(:good)

        FactoryGirl.create(
          :comment,
          :commentable_id => good.id,
          :commentable_type => "Good")
        FactoryGirl.create(
          :comment,
          :commentable_id => good.id,
          :commentable_type => "Good")

        Comment.for_good(good.id).should have(2).items
      end
    end
  end
end

