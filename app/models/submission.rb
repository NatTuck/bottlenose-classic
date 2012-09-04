class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :url, :student_notes, :raw_score, :updated_at

  belongs_to :assignment
  belongs_to :user

  validates :assignment_id, :presence => true
  validates :user_id,       :presence => true

  validate :user_is_registered_for_course

  delegate :course, :to => :assignment

  def late?
    updated_at > assignment.due_date
  end

  def score
    late? ? (raw_score / 2.0) : raw_score
  end

  private

  def user_is_registered_for_course
    user.courses.any? {|cc| cc.id == course.id }
  end
end
