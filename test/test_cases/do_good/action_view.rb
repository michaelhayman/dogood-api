# encoding: UTF-8

class DoGood::ActionViewTestCase < ActionView::TestCase
  include DoGood::TestHelper
  include DoGood::ARBCHelper
  include DoGood::AssertsHelper
  include DoGood::ContextHelper
  include DoGood::Testing::TaggedLogging

  def teardown
    super

    Rails.cache.clear
    Timecop.return
  end
end
