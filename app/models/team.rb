class Team < ActiveRecord::Base
  belongs_to :course
  has_many   :team_users, dependent: :destroy
  has_many   :users, through: :team_users
  has_many   :submissions

  validates :course_id,  presence: true
  validates :start_date, presence: true
  validates :users, presence: true
  validate :end_not_before_start

  def member_names
    users.sort_by {|uu| uu.invert_name }.map {|uu| uu.name }.join(", ")
  end

  # If the end date of a team is not set (nil) then this team does not
  # have an end date, and as such will always be active. Start and end
  # dates form a half open interval. This means that the team with a
  # start date of 2016-02-05 and end date of 2016-02-10 was a team
  # active for only 5 days, and specifically not active on the 10th of
  # February.
  def active?
    if self.end_date
      Date.current.between?(self.start_date, self.end_date - 1)
    else
      true
    end
  end

  def add_error(msg)
    errors[:base] << msg
  end


  private

  def end_not_before_start
    return if end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be not be before the start date")
    end
  end
end
