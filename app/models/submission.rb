class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :url, :student_notes, :score 

  validates :assignment_id, :presence => true
  validates :user_id,       :presence => true

  validate :user_is_registered_for_course

  delegate :course, :to => :assignment

  private

  def user_is_registered_for_course
    user.courses.any? {|cc| cc.id == course.id }
  end
end
