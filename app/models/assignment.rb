require 'securerandom'

class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id, :assignment, :due_date
  attr_accessible :assignment_file_name, :grading_file_name
  attr_accessible :assignment_file, :grading_file
  attr_accessible :points_available

  belongs_to :chapter
  has_many :submissions, :dependent => :destroy

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
      Dir.unlink(dn)
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
    if secret_dir.size > 0
      cleanup_assignment_file!
      cleanup_grading_file!
    end
  end

  def assignment_file=(data)
    return unless data

    self.assignment_file_name = data.original_filename 
    
    Dir.mkdir(assignments_base.join(secret_dir))

    path = assignment_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def grading_file=(data)
    return unless data

    self.grading_file_name = data.original_filename

    Dir.mkdir(grading_base.join(secret_dir))

    path = grading_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def best_submission_for(user)
    submissions.where(user_id: user.id).sort_by {|ss| ss.score}.last
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
