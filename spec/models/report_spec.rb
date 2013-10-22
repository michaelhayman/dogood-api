require 'spec_helper'

describe Report do
  context "has validations" do
    it "should be valid with all default values" do
      FactoryGirl.build(:report).should be_valid
    end

    it "should have a reportable id" do
      FactoryGirl.build(:report, reportable_id: "").should_not be_valid
    end

    it "should have a reportable type" do
      FactoryGirl.build(:report, reportable_type: "").should_not be_valid
    end

    it "should have a user" do
      FactoryGirl.build(:report, user_id: "").should_not be_valid
    end

    it "should be unique for a particular user" do
      report1 = FactoryGirl.create(
        :report,
        user_id: 1).
        should be_valid
      report2 = FactoryGirl.build(
        :report,
        user_id: 1).
        should_not be_valid
    end
  end
end

