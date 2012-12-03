class Registration < ActiveRecord::Base
  attr_accessible :course_id, :teacher, :user_id
  
  belongs_to :user
  belongs_to :course

  validates :user_id,   :presence => true
  validates :course_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :course_id }

  def answers_done
    qs = course.questions
    done = 0
    qs.each do |qq|
      qq.answers.where(user_id: user_id).each do |aa|
        done += 1 if aa.answer == aa.correct_answer
      end
    end
    "#{done} / #{qs.size}"
  end

  def update_assign_score!
    as = course.assignments
    score = 0
    total = 0
    as.each do |aa|
      total += aa.points_available
      score += aa.best_score_for(user)
    end

    write_attribute(:assign_score, "#{score.round(1)} / #{total.round(1)}")
    self.save!
  end

  def assign_score
    if self.read_attribute(:assign_score).nil?
      update_assign_score!
    end
    
    self.read_attribute(:assign_score)
  end
end
