class GradeType < ActiveRecord::Base
  belongs_to :course
  
  validates :name, :uniqueness => { :scope => :course_id }, length: { minimum: 2 }
  validates :weight, numericality: true
end
