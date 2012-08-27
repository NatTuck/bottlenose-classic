require 'test_helper'

class ChaptersControllerTest < ActionController::TestCase
  setup do
    @course = courses(:cs301)
    @intro  = chapters(:intro)
    @fred   = users(:fred)
    @john   = users(:john)
  end

  test "should get index" do
    get :index, {course_id: @course.id}, {user_id: @fred.id}
    assert_response :success
    assert_not_nil assigns(:chapters)
  end

  test "should get new" do
    get :new, {course_id: @course.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should create chapter" do
    assert_difference('Chapter.count') do
      post :create, {course_id: @course.id, 
        chapter: {course_id: @course.id, name: "Orders of Growth"}},
        {user_id: @fred.id}
    end

    assert_redirected_to assigns(:chapter)
  end

  test "should show chapter" do
    get :show, {id: @intro.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @intro.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update chapter" do
    put :update, {id: @intro.id, 
      chapter: {course_id: @course.id, name: "Intro to Haskell" }},
      {user_id: @fred.id}
    assert_redirected_to chapter_path(assigns(:chapter))
  end

  test "should destroy chapter" do
    assert_difference('Chapter.count', -1) do
      delete :destroy, {id: @intro.id}, {user_id: @fred.id}
    end

    assert_redirected_to course_chapters_path(@course)
  end
end
