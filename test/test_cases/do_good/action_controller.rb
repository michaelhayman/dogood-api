# encoding: UTF-8

class DoGood::ActionControllerTestCase < ActionController::TestCase
  include DoGood::TestHelper
  include DoGood::ARBCHelper
  include DoGood::AssertsHelper
  include DoGood::ContextHelper
  include DoGood::Testing::TaggedLogging
  include Devise::TestHelpers

  def teardown
    super

    Rails.cache.clear
    Timecop.return
  end
end
