require 'test_helper'

class ReportTest < DoGood::TestCase
  test "should be valid with all default values" do
    assert FactoryGirl.build(:report).valid?
  end

  test "should have a reportable id" do
    refute FactoryGirl.build(:report, reportable_id: "").valid?
  end

  test "should have a reportable type" do
    refute FactoryGirl.build(:report, reportable_type: "").valid?
  end

  test "should have a user" do
    refute FactoryGirl.build(:report, user_id: "").valid?
  end

  test "should be unique for a particular user" do
    report_1 = FactoryGirl.create(
      :report,
      user_id: 1)
    assert report_1.valid?

    report_2 = FactoryGirl.build(
      :report,
      user_id: 1)
    refute report_2.valid?
  end
end
