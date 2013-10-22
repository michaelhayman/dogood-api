require 'spec_helper'

describe Point do
  context "has validations" do
    it "should be valid with all default values" do
      FactoryGirl.build(:point).should be_valid
    end

    it "should be unique to a user" do
      FactoryGirl.create(:point).should be_valid
      FactoryGirl.build(:point).should_not be_valid
    end

    it "should have a link to a user id" do
      FactoryGirl.build(:point, to_user_id: "").should_not be_valid
    end

    it "should have a pointable id" do
      FactoryGirl.build(:point, pointable_id: "").should_not be_valid
    end

    it "should have a pointable type" do
      FactoryGirl.build(:point, pointable_type: "").should_not be_valid
    end

    it "should have a sub type" do
      FactoryGirl.build(:point, pointable_sub_type: "").should_not be_valid
    end

    it "should have points" do
      FactoryGirl.build(:point, points: "").should_not be_valid
    end
  end

  it "should remove points" do
    point = FactoryGirl.create(:point)
    points = [ point ]
    Point.remove_points(point.pointable_type, point.pointable_id, point.pointable_sub_type, point.to_user_id, point.from_user_id, point.points)
    Point.all.should be_empty
  end

  it "should record points" do
    point = FactoryGirl.create(:point)
    Point.record_points(point.pointable_type, point.pointable_id + 10, point.pointable_sub_type, point.to_user_id, point.from_user_id, point.points)
    point2 = Point.last
    Point.all.should =~ [ point, point2 ]
  end

  it "should reach a cap" do
    point = FactoryGirl.create(:point)
    point.cap_reached?.should be_true
  end

  it "should return a user's points" do
    user = FactoryGirl.create(:user)
    point = FactoryGirl.create(
      :point,
      :to_user_id => user.id)
    # true by default...
    Point.points_for_user(user.id).should eq user.points
  end

  it "should return a rank for a user" do
    user = FactoryGirl.create(:user)
    point = FactoryGirl.create(
      :point,
      :to_user_id => user.id)

    Point.rank_for_user(user.id).should == "B"
  end

  it "should return a sum of points for an arbitrary id" do
    point = FactoryGirl.create(:point)
    Point.points_for(point.pointable_type, point.pointable_id).should == point.points
  end

  it "should generate a log message" do
    p = Point.new
    msg = "Hey there"
    p.log(msg).should == "Point: #{p} #{msg}"
  end
end

