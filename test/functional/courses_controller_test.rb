require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @admin = users(:ken)
    @prof  = users(:fred)
    @user  = users(:john)
    
    @course1 = courses(:cs301)
    @course2 = courses(:cs599)
  end

  test "should get index" do
    get :index, {}, {:user_id => @user.id}
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "guest should have access to public course" do
    get :show, {id: @course1}
    assert_response :success
  end

  test "guest should not have access to private course" do
    get :show, {id: @course2}
    assert_response :redirect
    assert_match "not registered", flash[:error]
  end
  
  test "should get new" do
    get :new, {}, {:user_id => @admin.id}
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, {course: { name: "Worst Course Ever", late_options: "1,1,1" }}, {:user_id => @admin.id}
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test "should show course" do
    get :show, {id: @course1}, {:user_id => @user.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @course1}, {:user_id => @prof.id}
    assert_response :success
  end

  test "should update course" do
    put :update, {id: @course1, course: { name: @course1.name, late_options: "1,1,1" }}, {:user_id => @prof.id}
    assert_redirected_to course_path(assigns(:course))
  end
  
  test "updating late penalties should change scores" do
    put :update, {id: @course1, course: { name: @course1.name, late_options: "5,1,12" }}, {:user_id => @prof.id}

    sub = submissions(:john_hello)
    asg = assignments(:hello)

    assert_equal sub.assignment_id, asg.id
    assert_equal sub.score, 88
  end

  test "non-admin should not be able to update course" do
    put :update, {id: @course1, course: { name: @course1.name }}, {:user_id => @user.id}
    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, {id: @course2}, { user_id: @admin.id }
    end

    assert_redirected_to courses_path
  end

  test "non-admin should not be able to destroy course" do
    assert_difference('Course.count', 0) do
      delete :destroy, {id: @course1}, { user_id: @prof.id }
    end

    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end

  test "should export grades" do
    get :export_grades, {:id => @course1.id}, {:user_id => @prof.id}
    assert_match "John Fertitta", @response.body
    assert_response :ok
  end
end
