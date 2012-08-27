class Course < ActiveRecord::Base
  attr_accessible :name
  
  has_many :registrations
  has_many :users, :through => :registrations

  has_many :chapters

  validates :name, :length     => { :minimum => 2 },
                   :uniqueness => true
  
  def taught_by?(user)
    reg = Registration.find_by_course_id_and_user_id(self.id, user.id)
    reg and reg.teacher?
  end
  
  def teacher_registrations
    registrations.find_all {|reg| reg.teacher? }
  end

  def student_registrations
    registrations.find_all {|reg| !reg.teacher? }
  end
end
