class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user_id,   :presence => true
  validates :course_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :course_id }

  after_save do
    TeamSet.update_solo!(course)
  end

  def self.get(c_id, u_id)
    Registration.find_by_course_id_and_user_id(c_id, u_id)
  end

  def submissions
    Submission.where(user_id: user.id, course_id: course.id)
  end

  def best_subs
    Assignment.where(course_id: course_id).map do |aa|
      aa.main_submission_for(user)
    end.find_all do |ss|
      !ss.nil?
    end
  end

  def total_score
    total = 0.0

    course.buckets.each do |bb|
      ratio = bb.points_ratio(user)
      total += ratio * bb.weight
    end

    (total * 100.0).round
  end
end
