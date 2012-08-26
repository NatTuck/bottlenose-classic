require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @admin = users(:ken)
    @prof  = users(:fred)
    @user  = users(:john)
    
    @course = courses(:cs301)
  end

  test "should get index" do
    get :index, {}, {:user_id => @user.id}
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "should not get index unless logged in" do
    get :index
    assert_response :redirect
    assert_match "log in", flash[:error]
  end
  
  test "should get new" do
    get :new, {}, {:user_id => @admin.id}
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, {course: { name: @course.name }}, {:user_id => @admin.id}
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test "should show course" do
    get :show, {id: @course}, {:user_id => @user.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @course}, {:user_id => @prof.id}
    assert_response :success
  end

  test "should update course" do
    put :update, {id: @course, course: { name: @course.name }}, {:user_id => @prof.id}
    assert_redirected_to course_path(assigns(:course))
  end
  
  test "non-admin should not be able to update course" do
    put :update, {id: @course, course: { name: @course.name }}, {:user_id => @user.id}
    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, {id: @course}, { user_id: @admin.id }
    end

    assert_redirected_to courses_path
  end

  test "non-admin should not be able to destroy course" do
    assert_difference('Course.count', 0) do
      delete :destroy, {id: @course}, { user_id: @prof.id }
    end

    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end
end
