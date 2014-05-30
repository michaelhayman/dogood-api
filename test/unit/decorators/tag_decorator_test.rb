require 'test_helper'

class TagDecoratorTest < DoGood::TestCase
  def expected_hash
    tag = @tag.object
    {
      id: tag.id,
      name: tag.name
    }
  end

  def setup
    super

    @tag = FactoryGirl.create(:tag)
    @tag = TagDecorator.decorate(@tag)
  end
end

