require 'test_helper'

class TeamSetsControllerTest < ActionController::TestCase
  setup do
    @team_set = team_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:team_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team_set" do
    assert_difference('TeamSet.count') do
      post :create, team_set: { course_id: @team_set.course_id, name: @team_set.name }
    end

    assert_redirected_to team_set_path(assigns(:team_set))
  end

  test "should show team_set" do
    get :show, id: @team_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team_set
    assert_response :success
  end

  test "should update team_set" do
    patch :update, id: @team_set, team_set: { course_id: @team_set.course_id, name: @team_set.name }
    assert_redirected_to team_set_path(assigns(:team_set))
  end

  test "should destroy team_set" do
    assert_difference('TeamSet.count', -1) do
      delete :destroy, id: @team_set
    end

    assert_redirected_to team_sets_path
  end
end
