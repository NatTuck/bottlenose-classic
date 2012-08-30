class Chapter < ActiveRecord::Base
  attr_accessible :course_id, :name

  belongs_to :course
  has_many :lessons

  validates :course_id, :presence => true
  validates :name, :length => { :minimum => 2 }, 
                   :uniqueness => { :scope => :course_id }
end
