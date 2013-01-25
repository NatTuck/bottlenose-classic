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

  after_save :update_cache!

  def update_cache!
   reg = self.user.registration_for(self.course)
   reg.update_questions_score! unless reg.nil?
  end

  def late?
    if question.due.nil?
      false
    else
      created_at > question.due
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
