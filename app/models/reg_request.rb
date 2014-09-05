class RegRequest < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :course_id

  validates_presence_of :course_id

  belongs_to :course

  before_validation do
    unless self.email.nil?
      self.email = self.email.downcase
    end
  end

  def registered?
    course.users.any? {|uu| uu.email == email }
  end
end
