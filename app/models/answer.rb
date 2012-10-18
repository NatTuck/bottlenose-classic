class Answer < ActiveRecord::Base
  attr_accessible :answer, :question_id, :user_id, :attempts, :updated_at

  belongs_to :question
  belongs_to :user

  delegate :correct_answer, :to => :question, :allow_nil => false
 
  validates :question_id, :presence => true
  validates :user_id,     :presence => true
  validates :answer,      :presence => true

  validates_uniqueness_of :user_id, :scope => :question_id

  validate :user_is_registered_for_course

  delegate :course, :to => :question

  def late?
    if question.due_date.nil?
      false
    else
      created_at > question.due_date
    end
  end

  def correct?
    answer == correct_answer
  end

  def score
    if correct?
      late? ? 50 : 100
    else
      0
    end
  end

  private

  def user_is_registered_for_course
    user.courses.any? {|cc| cc.id == course.id }
  end
end
