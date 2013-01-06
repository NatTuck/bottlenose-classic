require 'securerandom'

class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :student_notes
  attr_accessible :raw_score, :updated_at, :upload
  attr_accessible :secret_dir, :file_name
  attr_accessible :grading_output, :grading_uid
  attr_accessible :teacher_score, :teacher_notes
  attr_accessible :ignore_late_penalty

  attr_protected :upload_id

  belongs_to :assignment
  belongs_to :user
  belongs_to :upload

  validates :assignment_id, :presence => true
  validates :user_id,       :presence => true
  validates :file_name,     :presence => true

  validates :teacher_score, :numericality => true, :allow_nil => true
  validates :raw_score,     :numericality => true, :allow_nil => true

  validate :user_is_registered_for_course

  validate :secret_dir,     :uniqueness => true

  delegate :course, :to => :assignment

  after_save     :update_cache!

  def update_cache!
   reg = self.user.registration_for(self.course)
   reg.update_assign_score! unless reg.nil?
  end

  def upload=(data)
    return if data.nil?

    up = Upload.new
    up.user_id = user_id
    up.store_meta!({
      type:       "Submission",
      user:       "#{user.name} (#{user.id})",
      course:     "#{course.name} (#{course.id})",
      assignment: "#{assignment.name} (#{assignment.id})",
      date:       Time.now.to_s
    })
    up.store_upload!(data)
    up.save!
  end

  def file_path
    file_name ? "/submissions/" + secret_dir + "/" + file_name : ""
  end

  def file_full_path
    Rails.root.join("public", "submissions", secret_dir, file_name)
  end

  def late?
    return false if new_record?
    created_at.to_date > assignment.due_date
  end

  def days_late
    return 0 unless late?
    due_on = assignment.due_date.to_time
    sub_on = created_at
    late_days = (sub_on - due_on) / 1.day
    late_days.floor
  end

  def late_penalty
    # Returns multiplier for post-penalty score.
    return 0.0 unless late?
    return 0.0 if ignore_late_penalty?
    
    (pen, del, max) = course.late_opts

    percent_off = (days_late / del) * pen
    percent_off = max if percent_off > max
    
    percent_off / 100.0
  end

  def late_mult
    1.0 - late_penalty
  end

  def score
    if teacher_score.nil?
      return 0 if raw_score.nil?
      raw_score * late_mult
    else
      teacher_score * late_mult
    end
  end

  def grade!
    return if secret_dir.nil?
    root = Rails.root.to_s
    system(%Q{(cd "#{root}" && script/grade-submission #{self.id})&})
  end

  private

  def user_is_registered_for_course
    user.courses.any? {|cc| cc.id == course.id }
  end
end
