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

  def active?
    if self.end_date
      # TODO: What assumptions about timezones does bottlenose make?
      DateTime.current.between?(self.start_date, self.end_date)
    else
      true
    end
  end

  def add_error(msg)
    errors[:base] << msg
  end
end
