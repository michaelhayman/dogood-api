class EntityTest < DoGood::TestCase
  test "should be valid with all default values" do
    assert FactoryGirl.build(:entity).valid?
  end

  test "should have a link id after saving" do
    @entity = FactoryGirl.build(:entity, link_id: "")
    @entity.save
    @entity.reload
    assert @entity.valid?
    assert_equal @entity.link_id, @entity.entityable_id
  end

  test "should have a link type" do
    refute FactoryGirl.build(:entity, link_type: "").valid?
  end

  test "should have a title" do
    refute FactoryGirl.build(:entity, title: "").valid?
  end

  test "should have a range" do
    refute FactoryGirl.build(:entity, range: "").valid?
  end

  test "should fill in link id it doesn't exist" do
    @entity = FactoryGirl.build(:entity, :no_link_id)
    @entity.save
    @entity.reload
    assert_equal @entity.link_id, @entity.entityable_id
  end

  test "should fill in link_id it's 0" do
    @entity = FactoryGirl.build(:entity, link_id: 0)
    @entity.save
    @entity.reload
    assert_equal @entity.link_id, @entity.entityable_id
  end
end

