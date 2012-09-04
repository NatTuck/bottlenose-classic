class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id, :assignment, :url, :due_date

  belongs_to :chapter
  has_many :submissions, :dependent => :destroy

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true
  validates :due_date,   :presence => true

  delegate :course, :to => :chapter

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
