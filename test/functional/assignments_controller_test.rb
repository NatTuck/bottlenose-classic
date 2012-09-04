require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  setup do
    @fred  = users(:fred)
    @john  = users(:john)
    @hello = assignments(:hello)
  end

  test "should get new" do
    get :new, {chapter_id: @hello.chapter_id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should create assignment" do
    assert_difference('Assignment.count') do
      post :create, {chapter_id: @hello.chapter_id, assignment: { assignment: "Dance a jig.",  
          name: "Useful Work", url: "http://example.com", chapter_id: @hello.chapter_id,
          due_date: '2019-05-22'}}, {user_id: @fred.id}
    end

    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should show assignment" do
    get :show, {id: @hello}, {user_id: @john.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @hello}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update assignment" do
    put :update, {id: @hello, assignment: { assignment: @hello.assignment, 
        name: "Something different", url: @hello.url }}, {user_id: @fred.id}
    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should destroy assignment" do
    assert_difference('Assignment.count', -1) do
        delete :destroy, {id: @hello}, {user_id: @fred.id}
    end

    assert_redirected_to @hello.chapter
  end
end
