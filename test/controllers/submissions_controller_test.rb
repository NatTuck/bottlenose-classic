require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @john_hello = submissions(:john_hello)
    @hello = assignments(:hello)

    @john = users(:john)
    @fred = users(:fred)
  end

  test "should get index" do
    get :index, {assignment_id: @hello.id}, {user_id: @fred.id}
    assert_response :success
    assert_not_nil assigns(:submissions)
  end

  test "should get new" do
    get :new, {assignment_id: @hello.id}, {user_id: @john.id}
    assert_response :success
  end

  test "should create submission" do
    skip
    # This is tested in integration tests, but it'd be nice to have it
    # working here too.

    upload = fixture_file_upload('files/HelloWorld.tgz','application/x-tgz')

    assert_difference('Submission.count') do
      post :create, {assignment_id: @hello.id, 
        submission: { student_notes: "blarg", file_name: "HelloWorld.tgz",
                      uploaded_file: upload }},
        {user_id: @john.id}
    end

    assert_redirected_to submission_path(assigns(:submission))
  end

  test "should show submission" do
    get :show, {id: @john_hello}, {user_id: @john.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @john_hello}, {user_id: @fred.id}
    assert_response :success
  end

  test "should get manual grade" do
    get :manual_grade, {assignment_id: @hello.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update submission" do
    put :update, {id: @john_hello}, {submission: { student_notes: "Bacon!", assignment_id: @john_hello.assignment_id, user_id: @john.id }}, {user_id: @fred.id}
    #assert_redirected_to submission_path(assigns(:submission))
    assert_response :redirect
  end

  #test "should destroy submission" do
  #  skip "Code to delete submissions intentionally disabled."
  #
  #  assert_difference('Submission.count', -1) do
  #    delete :destroy, {id: @john_hello}, {user_id: @fred.id}
  #  end

  #  assert_response :redirect
  #end
end
