class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user_id,   :presence => true
  validates :course_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :course_id }

  def assign_score_no_cache
    course.assignments.map {|aa| aa.main_score_for(user) }.inject(:&)
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
