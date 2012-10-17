class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :lesson_id, :question, :video

  belongs_to :lesson
  has_many :answers, :dependent => :destroy

  validates :lesson_id, :presence => true
  validates :question,  :format => { 
    :with    => /name=\"answer\[answer\]\"/,  
    :message => "must have a form with an 'answer[answer]' field."}
  
  delegate :course,  :to => :lesson
  delegate :chapter, :to => :lesson

  def due_date
    chapter.questions_due
  end

  before_validation do
    unless video.nil?
      video.sub! /width="\d+"/, 'width="1120"'
      video.sub! /height="\d+"/, 'height="630"'
    end
  end

  def answers_for(user)
    answers.where(user_id: user.id)
  end

  def best_score_for(user)
    answers_for(user).map {|aa| aa.score}.max
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
