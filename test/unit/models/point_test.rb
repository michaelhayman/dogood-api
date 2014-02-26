require 'test_helper'

class PointTest < DoGood::TestCase
  context "has validations" do
    test "should be valid with all default values" do
      assert FactoryGirl.build(:point).valid?
    end

    test "should be unique to a user" do
      assert FactoryGirl.create(:point).valid?
      refute FactoryGirl.build(:point).valid?
    end

    test "should have a link to a user id" do
      refute FactoryGirl.build(:point, to_user_id: "").valid?
    end

    test "should have a pointable id" do
      refute FactoryGirl.build(:point, pointable_id: "").valid?
    end

    test "should have a pointable type" do
      refute FactoryGirl.build(:point, pointable_type: "").valid?
    end

    test "should have a sub type" do
      refute FactoryGirl.build(:point, pointable_sub_type: "").valid?
    end

    test "should have points" do
      refute FactoryGirl.build(:point, points: "").valid?
    end
  end

  test "should remove points" do
    point = FactoryGirl.create(:point)
    points = [ point ]
    Point.remove_points(point.pointable_type, point.pointable_id, point.pointable_sub_type, point.to_user_id, point.from_user_id, point.points)
    assert_equal [], Point.all
  end

  test "should record points" do
    point = FactoryGirl.create(:point)
    Point.record_points(point.pointable_type, point.pointable_id + 10, point.pointable_sub_type, point.to_user_id, point.from_user_id, point.points)
    point2 = Point.last
    assert_equal [ point, point2 ], Point.all
  end

  test "should reach a cap" do
    point = FactoryGirl.create(:point)
    assert point.cap_reached?
  end

  test "should return a user's points" do
    user = FactoryGirl.create(:user)
    point = FactoryGirl.create(
      :point,
      :to_user_id => user.id)
    # true by default...
    assert_equal user.points, Point.points_for_user(user.id)
  end

  test "should return a rank for a user" do
    user = FactoryGirl.create(:user)
    point = FactoryGirl.create(
      :point,
      :to_user_id => user.id)

    assert_equal "B", Point.rank_for_user(user.id)
  end

  test "should return a sum of points for an arbitrary id" do
    point = FactoryGirl.create(:point)
    assert_equal point.points, Point.points_for(point.pointable_type, point.pointable_id)
  end

  test "should generate a log message" do
    p = Point.new
    msg = "Hey there"
    assert_equal "Point: #{p} #{msg}", p.log(msg)
  end
end
