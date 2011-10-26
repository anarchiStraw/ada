require 'test_helper'

class YouroomUsersControllerTest < ActionController::TestCase
  setup do
    @youroom_user = youroom_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:youroom_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create youroom_user" do
    assert_difference('YouroomUser.count') do
      post :create, youroom_user: @youroom_user.attributes
    end

    assert_redirected_to youroom_user_path(assigns(:youroom_user))
  end

  test "should show youroom_user" do
    get :show, id: @youroom_user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @youroom_user.to_param
    assert_response :success
  end

  test "should update youroom_user" do
    put :update, id: @youroom_user.to_param, youroom_user: @youroom_user.attributes
    assert_redirected_to youroom_user_path(assigns(:youroom_user))
  end

  test "should destroy youroom_user" do
    assert_difference('YouroomUser.count', -1) do
      delete :destroy, id: @youroom_user.to_param
    end

    assert_redirected_to youroom_users_path
  end
end
