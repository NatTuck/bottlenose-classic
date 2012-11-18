class RegRequest < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :course_id

  validates_presence_of :course_id

  belongs_to :course

  def registered?
    course.users.any? {|uu| uu.email == email }
  end
end
