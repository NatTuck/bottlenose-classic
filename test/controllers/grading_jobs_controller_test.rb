require 'test_helper'

class GradingJobsControllerTest < ActionController::TestCase
  setup do
    @grading_job = grading_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grading_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grading_job" do
    assert_difference('GradingJob.count') do
      post :create, grading_job: { started_at: @grading_job.started_at, submission_id: @grading_job.submission_id }
    end

    assert_redirected_to grading_job_path(assigns(:grading_job))
  end

  test "should show grading_job" do
    get :show, id: @grading_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grading_job
    assert_response :success
  end

  test "should update grading_job" do
    patch :update, id: @grading_job, grading_job: { started_at: @grading_job.started_at, submission_id: @grading_job.submission_id }
    assert_redirected_to grading_job_path(assigns(:grading_job))
  end

  test "should destroy grading_job" do
    assert_difference('GradingJob.count', -1) do
      delete :destroy, id: @grading_job
    end

    assert_redirected_to grading_jobs_path
  end
end
