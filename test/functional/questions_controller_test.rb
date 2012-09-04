require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @q1 = questions(:parens_awesome)
    @q2 = questions(:curlies_dumb)
    @q3 = questions(:there_yet)

    @fred = users(:fred)
    @john = users(:john)
  end

  test "should get new" do
    get :new, {lesson_id: @q1.lesson_id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, {lesson_id: @q1.lesson_id, question: { lesson_id: @q1.lesson_id, 
        question: @q1.question, correct_answer: "5" }}, {user_id: @fred.id}
    end

    assert_redirected_to edit_question_path(assigns(:question))
  end

  test "should get edit" do
    get :edit, {id: @q1.id}, {user_id: @fred.id}
    assert_response :success
  end

  test "should update question" do
    put :update, {id: @q1.id, question: { lesson_id: @q1.lesson_id, question: @q1.question,
        correct_answer: "pi/2"}}, {user_id: @fred.id}
    assert_redirected_to edit_question_path(assigns(:question))
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, {id: @q1.id}, {user_id: @fred.id}
    end

    assert_redirected_to @q1.lesson
  end
end
