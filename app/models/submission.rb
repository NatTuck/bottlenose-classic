class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :student_notes
  attr_accessible :raw_score, :updated_at, :upload
  attr_accessible :secret_dir, :file_name

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
