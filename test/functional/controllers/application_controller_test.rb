class ApplicationControllerTest < DoGood::ActionControllerTestCase
  tests ApplicationController

  def setup
    super
  end

  test "unauthorized error" do
    skip "this won't work"
    self.stub(:render_error) { nil }
    # p helper
    #p @helpers
    # p @controller.helpers
    # Books.any_instance.stubs(:title).returns("War and Peace")
    # Api::Helpers::RenderHelper.stub(:render_error) { "hey" }

    # self.stub(:render_error) { "hey" }
    # self.stub(:check_auth) { "hey" }
    # ActionView::Base.any_instance.stub(:render_error) { "error" }
    # helpers.stub(:render_error) { nil }
    # p @controller
    # p helpers.render_error
    # @controller.stub(:render_error) { nil }
    # @controller.check_auth
    raise DoGood::Api::Unauthorized.new
  end
end

