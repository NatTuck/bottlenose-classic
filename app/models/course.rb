class Course < ActiveRecord::Base
  attr_accessible :name, :footer, :late_options, :private, :term_id
  attr_accessible :questions_due_time

  belongs_to :term
  
  has_many :registrations
  has_many :users, :through => :registrations, :dependent => :restrict

  has_many :reg_requests, :dependent => :destroy

  has_many :chapters, :dependent => :restrict

  validates :name,    :length      => { :minimum => 2 },
                      :uniqueness  => true
  validates :late_options, :format => { :with => /^\d+,\d+,\d+$/ }

  def late_opts
    os = late_options.split(",")
    os.map {|oo| oo.to_i}
  end

  def taught_by?(user)
    return false if user.guest?
    reg = Registration.find_by_course_id_and_user_id(self.id, user.id)
    reg and reg.teacher?
  end
  
  def teacher_registrations
    registrations.where(teacher: true)
  end

  def student_registrations
    registrations.find_all {|reg| !reg.teacher? }
  end

  def active_registrations
    registrations.where(show_in_lists: true)
  end

  def students
    student_registrations.map {|reg| reg.user}
  end

  def teachers
    teacher_registrations.map {|reg| reg.user}
  end

  def assignments
    chapters.map {|cc| cc.assignments}.flatten
  end

  def questions
    chapters.map {|cc| cc.lessons}.flatten.map {|ll| ll.questions}.flatten
  end

  def first_teacher
    teachers.first
  end
end
