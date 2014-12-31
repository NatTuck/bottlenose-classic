require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  setup do
    @question = questions(:parens_awesome)
    @braces_q = questions(:curlies_dumb)

    @cs301    = courses(:cs301)

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

  test "should update score cache" do
    reg = @john.registration_for(@cs301)

    assert_equal Score.new(1, 3), reg.questions_score_no_cache,
      "Score as expected"
    assert_equal Score.new(1, 3), reg.questions_score,
      "Score cache as expected"

    qq = questions(:curlies_dumb)
    Answer.new(question_id: qq.id, user_id: @john.id, answer: "A").save!
    
    # Re-load object.
    reg = @john.registration_for(@cs301)
   
    assert_equal Score.new(2, 3), reg.questions_score_no_cache,
      "Score as expected after answer"

    assert_equal Score.new(2, 3), reg.questions_score,
      "Score cache as expected after add answer"
    
  end
end
