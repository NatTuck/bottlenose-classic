require 'securerandom'

class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :user
  belongs_to :upload

  validates :assignment_id, :presence => true
  validates :user_id,       :presence => true

  validates :teacher_score, :numericality => true, :allow_nil => true
  validates :raw_score,     :numericality => true, :allow_nil => true

  validate :user_is_registered_for_course
  validate :submitted_file_or_manual_grade
  validate :file_below_max_size

  delegate :course,    :to => :assignment
  delegate :file_name, :to => :upload, :allow_nil => true

  after_save :update_cache!
  before_destroy :cleanup!

  def update_cache!
   reg = self.user.registration_for(self.course)
   reg.update_assign_score! unless reg.nil?
  end

  def upload_file=(data)
    return if data.nil?

    unless upload_id.nil?
      raise Exception.new("Attempt to replace submission upload.")
    end

    self.upload_size = data.size

    if data.size > course.sub_max_size.megabytes
      return
    end

    up = Upload.new
    up.user_id = user_id
    up.store_meta!({
      type:       "Submission",
      user:       "#{user.name} (#{user.id})",
      course:     "#{course.name} (#{course.id})",
      assignment: "#{assignment.name} (#{assignment.id})",
      date:       Time.now.strftime("%Y/%b/%d %H:%M:%S %Z")
    })
    up.store_upload!(data)
    up.save!

    self.upload_id = up.id
    self.save!
      
    Audit.log("Sub #{id}: New submission upload by #{user.name} " +
              "(#{user.id}) with key #{up.secret_key}")
  end

  def file_path
    if upload_id.nil?
      ""
    else
      upload.path
    end
  end

  def file_full_path
    if upload_id.nil?
      ""
    else
      upload.full_path
    end
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
    return if upload_id.nil?
    root = Rails.root.to_s
    system(%Q{(cd "#{root}" && script/grade-submission #{self.id})&})
  end

  def cleanup!
    upload.cleanup! unless upload.nil?
  end

  private

  def user_is_registered_for_course
    unless user.courses.any? {|cc| cc.id == course.id }
      errors[:base] << "Not registered for this course."
    end
  end

  def submitted_file_or_manual_grade
    unless (not upload_id.nil?) || ignore_late_penalty
      errors[:base] << "You need to submit a file."
    end
  end

  def file_below_max_size
      msz = course.sub_max_size
      if upload_size > msz.megabytes
        errors[:base] << "Upload exceeds max size (#{upload_size} > #{msz} MB)."
      end
  end
end
