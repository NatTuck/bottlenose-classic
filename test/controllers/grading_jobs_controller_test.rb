require 'test_helper'

class GradingJobsControllerTest < ActionController::TestCase
  setup do
    @ken = create(:admin_user)
    @grading_job = GradingJob.create
  end

  test "should get index" do
    get :index, {}, user_id: @ken
    assert_response :success
    assert_not_nil assigns(:grading_jobs)
  end

  test "should show grading_job" do
    get :show, {id: @grading_job}, user_id: @ken
    assert_response :success
  end

  test "should destroy grading_job" do
    @derp = GradingJob.create

    assert_difference('GradingJob.count', -1) do
      delete :destroy, {id: @derp}, user_id: @ken
    end

    assert_redirected_to grading_jobs_path
  end
end
