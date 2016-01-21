class Bucket < ActiveRecord::Base
  belongs_to :course
  has_many   :assignments, dependent: :restrict_with_error

  validates :name, :uniqueness => { :scope => :course_id }, length: { minimum: 2 }
  validates :weight, numericality: true

  def points_earned(user)
    assignments.reduce(0) do |sum, aa|
      sub = aa.best_sub_for(user)
      sum + (sub.nil? ? 0 : sub.score)
    end
  end

  def points_available(user)
    assignments.reduce(0) { |sum, aa| sum + aa.points_available }
  end

  def points_ratio(user)
    return 0 if points_available(user).zero?
    points_earned(user) / points_available(user)
  end

  def points_percent(user)
    (points_ratio(user) * 100).round
  end
end
