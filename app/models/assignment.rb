class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id, :assignment, :due_date
  attr_accessible :assignment_file_name, :grading_file_name
  attr_accessible :assignment_file, :grading_file

  belongs_to :chapter
  has_many :submissions, :dependent => :destroy

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true
  validates :due_date,   :presence => true

  delegate :course, :to => :chapter

  before_destroy :cleanup!

  def cleanup_assignment_file!
    unless assignment_file_name.nil?
      path = Rails.root.join('public', 'assignments', assignment_file_name)
      File.unlink(path) if File.exists?(path)
    end
  end

  def cleanup_grading_file!
    unless grading_file_name.nil?
      path = Rails.root.join('public', 'assignments', 'grading', grading_file_name)
      File.unlink(path) if File.exists?(path)
    end
  end

  def cleanup!
    cleanup_assignment_file!
    cleanup_grading_file!
  end

  def assignment_file=(data)
    return unless data

    self.assignment_file_name = data.original_filename 

    path = Rails.root.join('public', 'assignments', assignment_file_name)
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def grading_file=(data)
    return unless data

    self.grading_file_name = data.original_filename

    path = Rails.root.join('public', 'assignments', 'grading', grading_file_name)
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
    sub.nil? ? nil : sub.score
  end
  
  def best_score_image_for(user)
    sub = best_submission_for(user)

    return "/assets/null-mark.png" if sub.nil? or sub.file_name.nil?
    return "/assets/wait-mark.gif" if sub.raw_score.nil?

    if sub.score > 75
      "/assets/check-mark.png"
    else
      "/assets/cross-mark.png"
    end
  end
end
