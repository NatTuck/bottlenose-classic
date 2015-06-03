class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user_id,   :presence => true
  validates :course_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :course_id }

  has_many :best_subs

  def submissions
    Submission.where(user_id: user.id, course_id: course.id)
  end

  def score
    points = best_subs.map {|b| b.score}.sum
    avail  = course.assignments.map {|a| a.points_available }.sum
    if avail == 0
      0
    else
      points / avail
    end
  end
end
