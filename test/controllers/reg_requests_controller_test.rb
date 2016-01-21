require 'test_helper'

class RegRequestsControllerTest < ActionController::TestCase
  setup do
    make_standard_course
    @mike = create(:user)
    @cs301 = @cs101

    @guest_req = create(:reg_request, course: @cs301)
    @ken_req   = create(:reg_request, user: @ken, course: @cs301)
  end

  test "should get index" do
    get :index, {course_id: @cs301.id}, {user_id: @fred.id}
    assert_response :success
    assert_not_nil assigns(:reqs)
  end

  test "should get new" do
    get :new, {course_id: @cs301.id}, {user_id: @guest_req.user.id}
    assert_response :success
  end

  test "should create reg_request" do
    assert_difference('RegRequest.count') do
      post :create, {course_id: @cs301.id, reg_request: { notes: "Let me in" }},
        {user_id: @mike.id}
    end

    assert_response :redirect
  end

  test "should reject duplicate reg_request" do
    assert_no_difference('RegRequest.count') do
      post :create, {course_id: @cs301.id, reg_request: { notes: "Let me in" }},
        {user_id: @guest_req.user.id}
    end

    assert_response :success
  end

  test "should show reg_request" do
    get :show, { id: @guest_req.id }, {user_id: @fred.id}
    assert_response :success
  end

  test "should destroy reg_request" do
    assert_difference('RegRequest.count', -1) do
      delete :destroy, {id: @guest_req.id}, {user_id: @fred.id}
    end

    assert_redirected_to course_reg_requests_path(@cs301)
  end
end
