require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "on time ansewr is not late" do
    assert not(answers(:on_time).late?)
  end 

  test "late answer is late" do
    assert answers(:late).late?
  end
end
