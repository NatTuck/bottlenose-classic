class Course < ActiveRecord::Base
  belongs_to :term
  
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations

  has_many :reg_requests, dependent: :destroy

  has_many :chapters,    dependent: :destroy
  has_many :grade_types, dependent: :destroy
  has_many :assignments, dependent: :restrict_with_error

  validates :name,    :length      => { :minimum => 2 },
                      :uniqueness  => true
  validates :late_options, :format => { :with => /\A\d+,\d+,\d+\z/ }

  validates :term_id, presence: true

  def late_opts
    # pen, del, max
    os = late_options.split(",")
    os.map {|oo| oo.to_i}
  end

  def taught_by?(user)
    return false if user.nil?
    reg = Registration.find_by_course_id_and_user_id(self.id, user.id)
    reg and reg.teacher?
  end
  
  def regs_sorted
    registrations.to_a.sort_by {|reg| reg.user.invert_name.downcase }
  end

  def teacher_registrations
    regs_sorted.find_all {|reg| reg.teacher? }
  end

  def student_registrations
    regs_sorted.find_all {|reg| !reg.teacher? }
  end

  def active_registrations
    regs_sorted.find_all {|reg| reg.show_in_lists? }
  end

  def students
    student_registrations.map {|reg| reg.user}
  end

  def teachers
    teacher_registrations.map {|reg| reg.user}
  end

  def first_teacher
    teachers.first
  end

  def add_registration(name, email, teacher = false)
    email.downcase!

    uu = User.find_by_email(email)
    if uu.nil?
      uu = User.new(name: name, email: email)
      if uu.save
        uu.send_auth_link_email!
      else
        return
      end
    end

    rr = registrations.where(user_id: uu.id).first
    if rr.nil?
      rr = Registration.create(user_id: uu.id, course_id: self.id, 
                               teacher: teacher, show_in_lists: !teacher)
    end

    rr
  end
end
