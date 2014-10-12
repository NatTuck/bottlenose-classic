class Chapter < ActiveRecord::Base
  belongs_to :course
  has_many :lessons, :dependent => :restrict_with_error
  has_many :assignments, :dependent => :restrict_with_error

  validates :course_id, :presence => true
  validates :name, :length => { :minimum => 2 }, 
                   :uniqueness => { :scope => :course_id }

  def questions
    lessons.map {|ll| ll.questions }.flatten
  end

  def questions_score(user)
     lessons.map {|ll| ll.questions_score(user) }.inject(:&) || Score.new(0, 0)
  end

  def assignments_score(user)
    assignments.map {|aa| aa.best_score_for(user) }.inject(:&) || Score.new(0, 0)
  end

  def next_due_date_for(user)
    as = assignments.map {|aa| aa.due_date }
    qs = questions.map   {|qq| qq.due_date }
    as.concat(qs).find_all {|dd| not dd.nil? }.sort.first || "none"
  end

  def prev
    xs = course.chapters.order(:name)

    while xs.length > 1
      if xs[1] == self
        return xs[0]
      end

      xs = xs[1..-1]
    end

    return nil
  end

  def next
    xs = course.chapters.order(:name)

    while xs.length > 1
      if xs[-2] == self
        return xs[-1]
      end

      xs = xs[0..-2]
    end

    return nil
  end
end
