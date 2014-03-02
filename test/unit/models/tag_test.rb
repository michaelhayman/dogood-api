require 'test_helper'

class TagTest < DoGood::TestCase
  context "validations" do
    test "default is valid" do
      assert FactoryGirl.build(:tag).valid?
    end
  end

  context "queries" do
    test "should return only 10 tags" do
      10.times do
        @tag = FactoryGirl.create(:tag, :cool)
        FactoryGirl.create(:tagging, hashtag: @tag)
      end
      assert_equal 10, Tag.popular.count
    end
  end
end
