class Team < ActiveRecord::Base
  belongs_to :course
  has_many   :users, through: :team_users

  validates :course_id,  presence: true
  validates :start_date, presence: true
end
