require 'test_helper'

class ReportsControllerTest < DoGood::ActionControllerTestCase
  tests ReportsController

  context "create" do
    def setup
      super

      @user = FactoryGirl.create(:user, :bob)
      @good = FactoryGirl.create(:good)
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

    test "should fail for a report that is posted twice" do
      sign_in @user

      post :create, {
        format: :json,
        report: {
          reportable_type: "Good",
          reportable_id: @good.id
        }
      }
      assert_response :success

      post :create, {
        format: :json,
        report: {
          reportable_type: "Good",
          reportable_id: @good.id
        }
      }

      assert_response :unprocessable_entity
    end

    test "should fail for db error" do
      sign_in @user

      stub_save_method(Report)

      post :create, {
        format: :json,
        report: {
          reportable_type: "Good",
          reportable_id: @good.id
        }
      }
      assert_response :internal_server_error
    end
  end
end

