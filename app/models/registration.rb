class Registration < ActiveRecord::Base
  attr_accessible :course_id, :teacher, :user_id
  
  belongs_to :user
  belongs_to :course

  validates :user_id,   :presence => true
  validates :course_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :course_id }

  def questions_score_no_cache
    course.chapters.map {|cc| cc.questions_score(user) }.inject(:&)
  end

  def update_questions_score!
    score = questions_score_no_cache
    write_attribute(:questions_score, "#{score || Score.new(0, 0)}")
    self.save!
  end

  def questions_score
    if self.read_attribute(:questions_score).nil?
      update_questions_score!
    end
    
    ss = self.read_attribute(:questions_score)
    (aa, bb) = ss.split("/").map {|nn| nn.to_i}
    Score.new(aa, bb)
  end

  def assign_score_no_cache
    course.assignments.map {|aa| aa.best_score_for(user) }.inject(:&)
  end

  def update_assign_score!
    score = assign_score_no_cache
    write_attribute(:assign_score, "#{score || Score.new(0, 0)}")
    self.save!
  end

  def assign_score
    if self.read_attribute(:assign_score).nil?
      update_assign_score!
    end
    
    ss = self.read_attribute(:assign_score)
    (aa, bb) = ss.split("/").map {|nn| nn.to_i}
    Score.new(aa, bb)
  end
end
