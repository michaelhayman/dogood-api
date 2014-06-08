
class DoGood::TestCase < ActiveSupport::TestCase
  include DoGood::TestHelper
  include DoGood::AssertsHelper

  def teardown
    super
    ActiveRecord::Base.subclasses.each(&:delete_all)
    Rails.cache.clear
  end
end
