class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id, :assignment, :due_date
  attr_accessible :file_name, :upload

  belongs_to :chapter
  has_many :submissions, :dependent => :destroy

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true
  validates :due_date,   :presence => true

  delegate :course, :to => :chapter

  before_destroy :cleanup!

  def cleanup!
    unless file_name.nil?
      path = Rails.root.join('public', 'assignments', file_name)
      File.unlink(path) if File.exists?(path)
    end
  end

  def upload=(data)
    return unless data
    cleanup!

    self.file_name = data.original_filename 

    path = Rails.root.join('public', 'assignments', file_name)
    File.open(path, 'wb') do |file|
      file.write(data.read)
    end
  end

  def file_path
    file_name ? "/assignments/" + file_name : ""
  end

  def best_submission_for(user)
    submissions.where(user_id: user.id).sort.last
  end

  def best_score_for(user)
    sub = best_submission_for(user)
    sub.nil? ? nil : sub.score
  end
  
  def best_score_image_for(user)
    best_score = best_score_for(user)

    return "/assets/null-mark.png" if best_score.nil?
    
    if best_score > 75
      "/assets/check-mark.png"
    else
      "/assets/cross-mark.png"
    end
  end
end
