require 'spec_helper'

describe Good do
  context "has validations" do
    it "should have a caption" do
      FactoryGirl.build(:good).should be_valid
    end

    it "should not have a caption that is too long" do
      string = "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
      # FactoryGirl.build(:good, :caption => string).should_not be_valid
      FactoryGirl.build(:good, :long_caption).should_not be_valid
    end

    it "should be associated with a user" do
      FactoryGirl.build(:good, :user_id => "").should_not be_valid
    end
  end



  pending "should add points" do
  end
  it "should return only goods belonging to a category" do
    good1 = FactoryGirl.create(:good, :category_id => 3)
    good2 = FactoryGirl.create(:good, :category_id => 5)
    Good.in_category(5).should have(1).item
  end

  it "should return goods by a specific user" do
    good1 = FactoryGirl.create(:good, :user_id => 3)
    good2 = FactoryGirl.create(:good, :user_id => 5)
    Good.by_user(5).should have(1).item
  end

  it "should return a specific good" do
    good1 = FactoryGirl.create(:good)
    good2 = FactoryGirl.create(:good)
    Good.specific(good2.id).should have(1).item
  end

  # duplication
  it "should return the standard goods" do
    11.times do
      FactoryGirl.create(:good)
    end

    Good.standard.should have(10).items
  end

  it "should return the most relevant goods" do
    11.times do
      FactoryGirl.create(:good)
    end

    Good.most_relevant.should have(10).items
  end

  pending "should return goods liked by a user"
  pending "should return goods posted or followed by a user"

  it "should block posting for a user that just created a good" do
    FactoryGirl.create(:good, :user_id => 11)
    Good.just_created_by(11).should have(1).item
  end

  pending "should return extra info" do
  end

  pending "should be meta-streamable" do
  end

end

