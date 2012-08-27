require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  setup do
    @lesson  = lessons(:yay_parens)
    @chapter = chapters(:intro)

    @fred = users(:fred)
    @john = users(:john)
  end

  test "should get index" do
    get :index, {chapter_id: @chapter.id}, {user_id: @fred.id}
    assert_response :success
    assert_not_nil assigns(:lessons)
  end

  test "should get new" do
    get :new, {chapter_id: @chapter.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should not get new for non-teacher" do
    get :new, {chapter_id: @chapter.id}, {user_id: @john.id}
    assert_response :redirect
    assert_match "not allowed", flash[:error]
  end

  test "should create lesson" do
    assert_difference('Lesson.count') do
      post :create, {chapter_id: @chapter.id, 
        lesson: { name: "Worst Lesson Ever", chapter_id: @chapter.id, 
                  video2: @lesson.video2, video: @lesson.video }},
        {user_id: @fred.id}
    end

    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test "should show lesson" do
    get :show, {id: @lesson}, {user_id: @john.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @lesson}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update lesson" do
    put :update, {id: @lesson, 
      lesson: { name: "Worst Lesson Ever", chapter_id: @chapter.id, 
                video2: @lesson.video2, video: @lesson.video }},
      {user_id: @fred.id}
    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test "should destroy lesson" do
    assert_difference('Lesson.count', -1) do
      delete :destroy, {id: @lesson}, {user_id: @fred.id}
    end

    assert_redirected_to chapter_lessons_path(@chapter)
  end
end
