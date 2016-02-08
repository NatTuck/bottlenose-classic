class Course < ActiveRecord::Base
  belongs_to :term

  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations

  has_many :reg_requests, dependent: :destroy

  has_many :buckets,     dependent: :destroy
  has_many :assignments, dependent: :restrict_with_error
  has_many :teams,       dependent: :destroy

  validates :name,    :length      => { :minimum => 2 },
                      :uniqueness  => true
  validates :late_options, :format => { :with => /\A\d+,\d+,\d+\z/ }

  validates :term_id, presence: true

  after_create do
    Bucket.create!(name: "Assignments", weight: 1.0, course: self)
  end

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
    registrations.includes(:user).to_a.sort_by do |reg|
      reg.user.invert_name.downcase
    end
  end

  def buckets_sorted
    buckets.order(:name)
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

  # TODO: Make these kinds of things return relations, not arrays. This
  # will allow code like that found in teams#index to perform optimized
  # joins.
  def students
    student_registrations.map {|reg| reg.user}
  end

  def teachers
    teacher_registrations.map {|reg| reg.user}
  end

  def first_teacher
    teachers.first
  end

  def total_bucket_weight
    buckets.reduce(0) {|sum, bb| sum + bb.weight }
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

  def score_summary
    as = self.assignments.includes(:best_subs)

    # Partition scores by user.
    avails = {}
    scores = {}
    as.each do |aa|
      avails[aa.bucket_id] ||= 0
      avails[aa.bucket_id] += aa.points_available

      aa.best_subs.each do |bs|
        scores[bs.user_id] ||= {}
        scores[bs.user_id][aa.bucket_id] ||= 0
        scores[bs.user_id][aa.bucket_id] += bs.score
      end
    end

    # Calculate percentages.
    percents = {}
    scores.each do |u_id, bs|
      percents[u_id] ||= {}

      bs.each do |b_id, score|
        if avails[b_id].zero?
          percents[u_id][b_id] = 0
        else
          percents[u_id][b_id] = (100 * score) / avails[b_id]
        end
      end
    end

    # Fill in for slackers, calc totals.
    totals = {}
    users.each do |uu|
      percents[uu.id] ||= {}
      totals[uu.id] = 0

      buckets.each do |bb|
        percents[uu.id][bb.id] ||= 0
        totals[uu.id] += bb.weight * percents[uu.id][bb.id]
      end
    end

    [percents, totals]
  end
end
