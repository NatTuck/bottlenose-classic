require 'securerandom'

class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :student_notes
  attr_accessible :raw_score, :updated_at, :upload
  attr_accessible :secret_dir, :file_name
  attr_accessible :grading_output, :grading_uid
  attr_accessible :teacher_score, :teacher_notes

  belongs_to :assignment
  belongs_to :user

  validates :assignment_id, :presence => true
  validates :user_id,       :presence => true
  validates :file_name,     :presence => true

  validate :user_is_registered_for_course

  delegate :course, :to => :assignment

  before_destroy :cleanup!

  def cleanup!
    unless secret_dir.nil? or file_name.nil?
      path = Rails.root.join('public', 'submissions', secret_dir, file_name)
      File.unlink(path) if File.exists?(path)

      dpath = Rails.root.join('public', 'submissions', secret_dir)
      Dir.rmdir(dpath) if File.exists?(dpath)
    end
  end

  def upload=(data)
    return if data.nil?
    cleanup!

    self.secret_dir = SecureRandom.urlsafe_base64
    dpath = Rails.root.join('public', 'submissions', secret_dir)
    Dir.mkdir(dpath)

    self.file_name  = data.original_filename
    path = Rails.root.join('public', 'submissions', secret_dir, file_name)
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def file_full_path
    Rails.root.join('public', 'submissions', secret_dir, file_name)    
  end

  def file_path
    return "" if secret_dir.nil?
    file_name ? "/submissions/" + secret_dir + "/" + file_name : ""
  end

  def late?
    created_at.to_date > assignment.due_date
  end

  def days_late
    due_on = assignment.due_date.to_time
    sub_on = created_at
    late_days = (sub_on - due_on) / 1.day
    late_days.floor
  end

  def late_penalty
    # Returns multiplier for post-penalty score.
    return 1.0 unless late?
    
    (pen, del, max) = course.late_opts

    percent_off = (days_late / del) * pen
    percent_off = max if percent_off > max
    
    1.0 - (percent_off / 100.0)
  end

  def score
    if teacher_score
      return teacher_score
    else
      return 0 if raw_score.nil?
      raw_score * late_penalty
    end
  end

  def score_image
    if raw_score.nil? and teacher_score.nil?
      return "/assets/wait-mark.gif"
    end

    if score > 75
      "/assets/check-mark.png"
    else
      "/assets/cross-mark.png"
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
