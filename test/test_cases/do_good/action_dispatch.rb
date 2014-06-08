class DoGood::ActionDispatchIntegrationTestCase < ActionDispatch::IntegrationTest
  include DoGood::TestHelper
  include DoGood::ARBCHelper
  include DoGood::AssertsHelper

  def teardown
    super

    Rails.cache.clear
  end
end
