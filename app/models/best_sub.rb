class BestSub < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  belongs_to :assignment
  
  validates :assignment_id, :uniqueness => { :scope => :user_id }
  validates :user_id, :uniqueness => { :scope => :assignment_id }

  delegate :created_at, to: :submission

  validate :submission_matches_assignment

  def submission_matches_assignment
    if submission.assignment_id != assignment_id
      errors[:base] << "Submission / assignment mismatch."
    end
  end
end
