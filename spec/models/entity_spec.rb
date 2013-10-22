require 'spec_helper'

describe Entity do
  context "has validations" do
    it "should be valid with all default values" do
      FactoryGirl.build(:entity).should be_valid
    end

    it "should have a link" do
      FactoryGirl.build(:entity, link: "").should_not be_valid
    end

    it "should have a link id" do
      FactoryGirl.build(:entity, link_id: "").should_not be_valid
    end

    it "should have a link type" do
      FactoryGirl.build(:entity, link_type: "").should_not be_valid
    end

    it "should have a title" do
      FactoryGirl.build(:entity, title: "").should_not be_valid
    end

    it "should have a entityable id" do
      FactoryGirl.build(:entity, entityable_id: "").should_not be_valid
    end

    it "should have a entityable type" do
      FactoryGirl.build(:entity, entityable_type: "").should_not be_valid
    end

    it "should have a range" do
      FactoryGirl.build(:entity, range: "").should_not be_valid
    end
  end
end

