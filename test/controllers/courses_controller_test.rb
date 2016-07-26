require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    make_standard_course
    @mike  = create(:user)

    @course1 = @cs101
    @course2 = create(:course)

    @term = @course1.term
  end

  test "should get index" do
    get :index, {}, {:user_id => @john.id}
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "non-enrolled user should have access to course main page" do
    get :show, {id: @course1}, {user_id: @mike.id}
    assert_response :success
  end

  test "should get new" do
    get :new, {}, {user_id: @ken.id}
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, {course: {
        name: "Worst Course Ever", term_id: @term.id, late_options: "1,1,1" }},
        {:user_id => @ken.id}
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test "should show course" do
    get :show, {id: @course1}, {user_id: @john.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @course1}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update course" do
    put :update, {id: @course1, course: { name: @course1.name, late_options: "1,1,1" }},
      {:user_id => @fred.id}
    assert_redirected_to course_path(assigns(:course))
  end

  test "updating late penalties should change scores" do
    a1  = create(:assignment, course: @course1, due_date: (Time.now - 5.days),
                 team_set: @solo)
    sub = create(:submission, assignment: a1, user: @john, 
                 team: @john_team, teacher_score: 100)

    put :update, {id: @course1, course: 
                   { name: @course1.name, late_options: "5,1,12" }},
                 {:user_id => @fred.id}
    assert_response :redirect

    sub.reload

    assert_equal sub.assignment_id, a1.id
    assert_equal sub.score, 88
  end

  test "non-admin should not be able to update course" do
    put :update, {id: @course1, course: { name: @course1.name }}, {:user_id => @john.id}
    assert_response :redirect
    assert_match "not allowed", flash[:error]
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, {id: @course2}, { user_id: @ken.id }
    end

    assert_redirected_to courses_path
  end

  test "non-admin should not be able to destroy course" do
    assert_difference('Course.count', 0) do
      delete :destroy, {id: @course1}, { user_id: @fred.id }
    end

    assert_response :redirect
    assert_match "don't have permission", flash[:error]
  end

  test "should export grades" do
    a1 = create(:assignment, course: @course1, team_set: @solo)
    sub1 = create(:submission, assignment: a1, user: @john, 
                  team_id: @john_team, teacher_score: 20)

    get :export_grades, {:id => @course1.id}, {:user_id => @fred.id}
    assert_match @john.name, @response.body
    assert_response :ok
  end

  test "should get public page if public" do
    get :public, { id: @course1 }
    assert_response :ok
  end

  test "should not get public page unless public" do
    get :public, { id: @course2 }
    assert_response :redirect
  end
end
