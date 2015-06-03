class GradeType < ActiveRecord::Base
  belongs_to :course
  has_many   :assignments, dependent: :restrict_with_error
  
  validates :name, :uniqueness => { :scope => :course_id }, length: { minimum: 2 }
  validates :weight, numericality: true
end
