require 'test_helper'

class ReportsControllerTest < DoGood::ActionControllerTestCase
  tests ReportsController

  context "create" do
    def setup
      super

      @user = FactoryGirl.create(:user, :bob)
    end

    test "should fail for an unauthorized user" do
      post :create, {
        format: :json,
        user: {
          email: @user.email
        }
      }
      json = jsonify(response)

      assert_response :unauthorized
    end

    test "should succeed with proper parameters" do
      sign_in @user
      @good = FactoryGirl.create(:good)

      post :create, {
        format: :json,
        report: {
          reportable_type: "Good",
          reportable_id: @good.id
        }
      }
      json = jsonify(response)

      assert_response :success
    end

    test "should fail for a report that fails validations" do
      sign_in @user
      @good = FactoryGirl.create(:good)

      post :create, {
        format: :json,
        report: {
          reportable_type: "",
          reportable_id: ""
        }
      }
      json = jsonify(response)

      assert_response :unprocessable_entity
    end
  end
end

