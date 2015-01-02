require 'test_helper'

class RegRequestsControllerTest < ActionController::TestCase
  setup do
    @guest_req = reg_requests(:guest_req)
    @ken_req   = reg_requests(:ken_req)

    @fred  = users(:fred)
    @cs301 = courses(:cs301)
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
      post :create, {course_id: @cs301.id, reg_request: { notes: @guest_req.notes }}, 
        {user_id: @guest_req.user.id}
    end

    assert_response :redirect
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
