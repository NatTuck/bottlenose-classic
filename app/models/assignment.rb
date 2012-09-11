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

  def cleanup_assignment_file!
    unless assignment_file_name.nil?
      path = assignment_full_path
      File.unlink(path) if File.exists?(path)
    end
  end

  def cleanup_grading_file!
    unless grading_file_name.nil?
      path = grading_full_path
      File.unlink(path) if File.exists?(path)
    end
  end

  def assignment_full_path
    Rails.root.join('public', 'assignments', assignment_file_name)
  end

  def grading_full_path
    Rails.root.join('public', 'assignments', 'grading', grading_file_name)
  end

  def cleanup!
    cleanup_assignment_file!
    cleanup_grading_file!
  end

  def assignment_file=(data)
    return unless data

    self.assignment_file_name = data.original_filename 

    path = assignment_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def grading_file=(data)
    return unless data

    self.grading_file_name = data.original_filename

    path = grading_full_path
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def file_path
    assignment_file_name ? "/assignments/" + assignment_file_name : ""
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
    return sub.score_image
  end
end
