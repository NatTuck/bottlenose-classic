class Question < ActiveRecord::Base
  attr_accessible :name, :correct_answer, :lesson_id
  attr_accessible :question, :question_form, :explanation

  belongs_to :lesson
  has_many :answers, :dependent => :destroy

  validates :lesson_id, :presence => true
  validates :question,  :presence => true

  delegate :course,  :to => :lesson
  delegate :chapter, :to => :lesson

  def due_date
    lesson.questions_due
  end

  before_validation do
    unless explanation.nil?
      explanation.sub! /width="\d+"/, 'width="1120"'
      explanation.sub! /height="\d+"/, 'height="630"'
    end
  end

  def answers_for(user)
    answers.where(user_id: user.id)
  end

  def best_score_for(user)
    best = answers_for(user).map {|aa| aa.score}.max || 0

    if best > 75
      Score.new(1, 1)
    else
      Score.new(0, 1)
    end
  end

  def best_score_image_for(user)
    best_score = best_score_for(user)

    return "/assets/null-mark.png" if best_score.nil?
    
    if best_score.points > 0
      "/assets/check-mark.png"
    else
      "/assets/cross-mark.png"
    end
  end
end
