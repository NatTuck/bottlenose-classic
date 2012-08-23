class Lesson < ActiveRecord::Base
  attr_accessible :course_id, :name, :question_id, :video, :video2
end
