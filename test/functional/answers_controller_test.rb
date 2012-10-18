require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  setup do
    @question = questions(:parens_awesome)
    @braces_q = questions(:curlies_dumb)

    @fred     = users(:fred)
    @john     = users(:john)
    @right    = answers(:right)
    @wrong    = answers(:wrong)
  end

  test "should create answer" do
    assert_difference('Answer.count') do
      xhr :post, :create, {question_id: @braces_q.id,
        answer: {question_id: @braces_q.id, answer: "seven" }}, 
        {user_id: @john.id}
    end

    assert_response :success
  end

  test "should destroy answer" do
    assert_difference('Answer.count', -1) do
      delete :destroy, {id: @wrong.id}, {user_id: @fred.id}
    end

    assert_redirected_to @wrong.question.lesson
  end
end
