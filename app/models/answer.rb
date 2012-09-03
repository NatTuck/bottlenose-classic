class Answer < ActiveRecord::Base
  attr_accessible :answer, :question_id, :user_id

  belongs_to :question
  belongs_to :user

  delegate :correct_answer, :to => :question,     :allow_nil => false

  validates :question_id, :presence => true
  validates :user_id,     :presence => true
  validates :answer,      :presence => true

  validate :user_is_registered_for_course

  delegate :course, :to => :question

  def score
    if answer == correct_answer
      100
    else
      0
    end
  end

  private

  def user_is_registered_for_course
    user.courses.any? {|cc| cc.id == course.id }
  end
end
