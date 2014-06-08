
class DoGood::ActionControllerTestCase < ActionController::TestCase
  include DoGood::TestHelper
  include DoGood::AssertsHelper
  include Devise::TestHelpers

  def teardown
    super

    ActiveRecord::Base.subclasses.each(&:delete_all)
    Rails.cache.clear
  end
  private
    def stub_save_method(class_name)
      any_instance_of(class_name) do |klass|
          stub(klass).save { false }
      end
    end
end
