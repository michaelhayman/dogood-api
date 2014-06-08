class DoGood::ActionViewTestCase < ActionView::TestCase
  include DoGood::TestHelper
  include DoGood::AssertsHelper

  def teardown
    super

    Rails.cache.clear
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
