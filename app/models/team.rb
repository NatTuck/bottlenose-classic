class Team < ActiveRecord::Base
  belongs_to :course
  has_many   :team_users, dependent: :destroy
  has_many   :users, through: :team_users
  has_many   :submissions

  validates :course_id,  presence: true
  validates :start_date, presence: true
  validates :users, presence: true

  def member_names
    users.sort_by {|uu| uu.invert_name }.map {|uu| uu.name }.join(", ")
  end

  def add_error(msg)
    errors[:base] << msg
  end
end
