class EntitySerializerTest < DoGood::TestCase
  def expected_hash
    {
      entities: {
        id: @entity.id,
        link: @entity.link,
        link_type: @entity.link_type,
        link_id: @entity.link_id,
        title: @entity.title,
        range: @entity.range
      }
    }
  end

  def setup
    super

    @entity = FactoryGirl.create(:entity).decorate
    @serializer = EntitySerializer.new @entity, root: "entities"
  end

  test "output" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

