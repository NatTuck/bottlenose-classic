require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin_user)
    @user  = create(:user)
    @jack  = create(:user)
  end

  test "should get index" do
    get :index, {}, {:user_id => @admin.id}
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "non admin should not get index" do
    get :index, {}, {:user_id => @user.id}
    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end

  test "should get new" do
    get :new, {}, {:user_id => @admin.id}
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, {user: { email: "bob@dole.com", name: "Bob Dole", auth_key: "derp" }},
        {:user_id => @admin.id}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, {id: @user}, {:user_id => @admin.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @user}, {:user_id => @admin.id}
    assert_response :success
  end

  test "should update user" do
    put :update, {id: @user, user: { email: @user.email, name: @user.name }},
      {:user_id => @admin.id}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, {id: @jack}, {:user_id => @admin.id}
    end

    assert_redirected_to users_path
  end
end
