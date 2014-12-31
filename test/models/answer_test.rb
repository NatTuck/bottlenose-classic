require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "on time answers not late" do
    assert not(answers(:on_time).late?)
    assert not(answers(:water_on_time).late?)
  end 

  test "late answers late" do
    assert answers(:late).late?
    assert answers(:water_late).late?
  end
end
