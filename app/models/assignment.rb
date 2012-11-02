require 'securerandom'

class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id, :assignment, :due_date
  attr_accessible :assignment_file_name, :grading_file_name
  attr_accessible :assignment_file, :grading_file
  attr_accessible :points_available, :hide_grading

  belongs_to :chapter
  has_many :submissions, :dependent => :restrict

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true
  validates :due_date,   :presence => true
  validates :points_available, :numericality => true

  delegate :course, :to => :chapter

  before_destroy :cleanup!

  def secret_dir
    if read_attribute(:secret_dir).nil?
      write_attribute(:secret_dir, SecureRandom.urlsafe_base64)
    end
    read_attribute(:secret_dir)
  end

  def assignments_base
    Rails.root.join('public', 'assignments')
  end

  def grading_base
    assignments_base.join('grading')
  end

  def cleanup_file!(base, file)
    fn = base.join(secret_dir, file)
    if File.exists?(fn)
      File.unlink(fn)
    end

    dn = base.join(secret_dir)
    if Dir.exists?(dn)
      begin
        Dir.unlink(dn)
      rescue
        logger.debug("Error removing directory, skipping.")
      end
    end
  end

  def cleanup_assignment_file!
    return if assignment_file_name.nil?
    cleanup_file!(assignments_base, assignment_file_name)
  end

  def cleanup_grading_file!
    return if grading_file_name.nil?
    cleanup_file!(grading_base, grading_file_name)
  end

  def assignment_full_path
    assignments_base.join(secret_dir, assignment_file_name)
  end

  def grading_full_path
    assignments_base.join('grading', secret_dir, grading_file_name)
  end

  def assignment_file_path
    return "" if assignment_file_name.nil?
    '/assignments/' + secret_dir + '/' + assignment_file_name
  end

  def grading_file_path
    return "" if grading_file_name.nil?
    '/assignments/grading/' + secret_dir + '/' + grading_file_name
  end

  def cleanup!
    cleanup_assignment_file!
    cleanup_grading_file!
  end

  def assignment_file=(data)
    return unless data
    cleanup_assignment_file!

    self.assignment_file_name = data.original_filename 
    
    unless Dir.exists?(assignments_base.join(secret_dir))
      Dir.mkdir(assignments_base.join(secret_dir))
    end

    path = assignment_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def grading_file=(data)
    return unless data
    cleanup_grading_file!

    self.grading_file_name = data.original_filename

    unless Dir.exists?(grading_base.join(secret_dir))
      Dir.mkdir(grading_base.join(secret_dir))
    end

    path = grading_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def submissions_for(user)
    submissions.where(user_id: user.id).order(:created_at).reverse
  end

  def best_submission_for(user)
    subs = submissions_for(user)
    if subs.empty?
      Submission.new(user_id: user.id, assignment_id: self.id, file_name: "none")
    else
      subs.sort_by {|ss| ss.created_at}.last
    end
  end

  def best_submissions
    course.student_registrations.sort_by {|sr| sr.user.name}.map do |sreg|
      best_submission_for(sreg.user)
    end
  end

  def best_score_for(user)
    sub = best_submission_for(user)
    sub.nil? ? 0 : sub.score
  end
  
  def best_score_image_for(user)
    sub = best_submission_for(user)

    return "/assets/null-mark.png" if sub.nil? or sub.file_name.nil?
    sub.score_image
  end
end
