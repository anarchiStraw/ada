require 'test_helper'

class NoticeSettingsControllerTest < ActionController::TestCase
  setup do
    @notice_setting = notice_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notice_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notice_setting" do
    assert_difference('NoticeSetting.count') do
      post :create, notice_setting: @notice_setting.attributes
    end

    assert_redirected_to notice_setting_path(assigns(:notice_setting))
  end

  test "should show notice_setting" do
    get :show, id: @notice_setting.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notice_setting.to_param
    assert_response :success
  end

  test "should update notice_setting" do
    put :update, id: @notice_setting.to_param, notice_setting: @notice_setting.attributes
    assert_redirected_to notice_setting_path(assigns(:notice_setting))
  end

  test "should destroy notice_setting" do
    assert_difference('NoticeSetting.count', -1) do
      delete :destroy, id: @notice_setting.to_param
    end

    assert_redirected_to notice_settings_path
  end
end
