require 'test_helper'

class TeamSetsControllerTest < ActionController::TestCase
  setup do
    @course   = create(:course)
    @team_set = create(:team_set, course: @course)

    @fred = create(:user)
    @mark = create(:user)
    create(:registration, user: @fred, course: @course, teacher: true)
  end

  test "should get index" do
    get :index, { course_id: @course }, { user_id: @fred }
    assert_response :success
    assert_not_nil assigns(:team_sets)
  end

  test "student should not get index" do
    get :index, { course_id: @course }, { user_id: @mark }
    assert_response :redirect
  end

  test "should get new" do
    get :new, { course_id: @course }, { user_id: @fred }
    assert_response :success
  end

  test "should create team_set" do
    assert_difference('TeamSet.count') do
      post :create, { course_id: @course, 
                      team_set: { course_id: @team_set.course_id, 
                                  name: "Another Team Set" }},
                    { user_id: @fred }
    end

    assert_redirected_to course_team_set_path(@course, assigns(:team_set))
  end

  test "should show team_set" do
    get :show, { course_id: @course, id: @team_set }, { user_id: @fred }
    assert_response :success
  end

  test "should update team_set" do
    patch :update, { course_id: @course, id: @team_set, 
                     team_set: { course_id: @team_set.course_id, 
                                 name: "Another Name" } },
                   { user_id: @fred }
    assert_redirected_to course_team_set_path(@course, assigns(:team_set))
  end

  test "should destroy team_set" do
    assert_difference('TeamSet.count', -1) do
      delete :destroy, { course_id: @course, id: @team_set }, { user_id: @fred }
    end

    assert_redirected_to course_team_sets_path(@course)
  end
end
