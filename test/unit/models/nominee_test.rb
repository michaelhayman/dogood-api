require 'test_helper'

class NomineeTest < DoGood::TestCase
  test "should have a full name" do
    assert FactoryGirl.build(:nominee).valid?
    refute FactoryGirl.build(:nominee, full_name: "").valid?
  end
end
