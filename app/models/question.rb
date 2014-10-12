require 'score'

class Question < ActiveRecord::Base
  belongs_to :lesson
  has_many :answers, :dependent => :destroy

  validates :lesson_id, :presence => true
  validates :question,  :presence => true

  delegate :course,  :to => :lesson
  delegate :chapter, :to => :lesson

  before_save do
    root = Rails.root.to_s
    system(%Q{(cd "#{root}" && script/refresh-score-caches)&})
  end

  def due
    return nil if lesson.questions_due.nil?
    time = lesson.questions_due.to_time
    
    if course.questions_due_time.nil?
      time += 1.day
    else
      base_date = course.questions_due_time.to_date.to_time
      delta = course.questions_due_time - base_date

      if delta == 0
        time += 1.day
      else
        time += delta
      end
    end

    time
  end

  def due_date
    if due.nil?
      nil
    else
      due.to_date
    end
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
