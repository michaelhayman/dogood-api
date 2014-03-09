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
  private
    def stub_save_method(class_name)
      any_instance_of(class_name) do |klass|
          stub(klass).save { false }
      end
    end
end
