require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @fred = users(:fred)
    @alan = users(:alan)
    @john = users(:john)
    @mike = users(:mike)

    @fred_reg = registrations(:fred_cs301)
    @john_reg = registrations(:john_cs301)

    @cs301 = courses(:cs301)
  end

  test "should get index" do
    get :index, {:course_id => @cs301.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should not get index unless logged in" do
    get :index, {:course_id => @cs301.id}
    assert_response :redirect
    assert_match "You need to register first", flash[:error]
  end

  test "non-teacher should not get index" do
    get :index, {:course_id => @cs301.id}, {user_id: @john.id}
    assert_response :redirect
    assert_match "not allowed", flash[:error]
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, { course_id: @cs301.id, user_name: @mike.name, user_email: @mike.email,
        registration: { user_id: @mike.id, course_id: @cs301.id }},
        {user_id: @fred.id}
    end

    assert_response :redirect
  end

  test "should show registration" do
    get :show, {:course_id => @cs301.id, id: @john_reg.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:course_id => @cs301.id, id: @john_reg.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update registration" do
    put :update, {course_id: @cs301.id, id: @john_reg.id, 
      registration: { user_id: @john.id, course_id: @cs301.id, teacher: true }}, 
      {user_id: @fred.id}

    assert_response :redirect
  end

  test "should toggle show-in-reports" do
    post :toggle_show, { format: 'js', course_id: @cs301.id, id: @john_reg.id }, { user_id: @fred.id }
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, {:course_id => @cs301.id, id: @john_reg.id}, 
        {user_id: @fred.id}
    end

    assert_redirected_to course_registrations_path(@cs301)
  end
end
