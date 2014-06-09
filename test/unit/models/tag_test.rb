require 'test_helper'

class TagTest < DoGood::TestCase
  test "popular should return only 10 tags" do
    10.times do
      @tag = FactoryGirl.create(:tag, title: Faker::Internet.domain_word)
    end
    assert_equal 10, Tag.popular.size.size
  end

  test "only returns tag type entities" do
    @tag = FactoryGirl.create(:tag)
    @entity = FactoryGirl.create(:entity)
    assert_equal Tag.all, [ @tag ]
  end

  test "matching should return tags matching a string" do
    @tag = FactoryGirl.create(:tag).decorate
    assert_equal @tag.title, Tag.matching("#awe")[0].title
  end
end
