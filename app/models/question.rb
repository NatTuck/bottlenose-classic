class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :lesson_id, :question

  belongs_to :lesson
  has_many :answers
end
