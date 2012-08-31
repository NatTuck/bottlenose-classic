require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  setup do
    @lesson = lessons(:yay_parens)
    @fred   = users(:fred)
    @john   = users(:john)
    @right  = answers(:right)
    @wrong  = answers(:wrong)
  end

  test "should create answer" do
    assert_difference('Answer.count') do
      xhr :post, :create, {lesson_id: @lesson.id, 
        answer: { lesson_id: @lesson.id, answer: "seven" }}, 
        {user_id: @john.id}
    end

    assert_response :success
  end

  test "should destroy answer" do
    assert_difference('Answer.count', -1) do
      delete :destroy, {lesson_id: @lesson.id, id: @wrong.id}, {user_id: @fred.id}
    end

    assert_redirected_to @lesson
  end
end
