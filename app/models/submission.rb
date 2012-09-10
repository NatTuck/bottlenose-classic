require 'securerandom'

class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :user_id, :student_notes
  attr_accessible :raw_score, :updated_at, :upload
  attr_accessible :secret_dir, :file_name
  attr_accessible :grading_output, :grading_uid
  attr_accessible :teacher_grade, :teacher_notes

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
    updated_at > assignment.due_date
  end

  def score
    return 0 if raw_score.nil?
    late? ? (raw_score / 2.0) : raw_score
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
