require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin_user)
    @prof  = create(:user)
  end

  test "non-admin should not get settings" do
    get :index, {}, { user_id: @prof.id }
    assert_response :redirect
  end

  test "index should show defaults" do
    Settings.clear_test!

    get :index, {}, { user_id: @admin.id }
    assert_response :success
    assert_match "noreply@example.com", @response.body
  end

  test "should save_settings" do
    post :save, { site_email: "somebody@example.com", backup_login: "" },
      { user_id: @admin.id }

    assert_response :redirect
    assert_match "Settings Saved", flash[:notice]
    assert_equal Settings['site_email'], "somebody@example.com"
  end
end
