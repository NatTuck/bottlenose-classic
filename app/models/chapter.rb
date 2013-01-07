class Chapter < ActiveRecord::Base
  attr_accessible :course_id, :name

  belongs_to :course
  has_many :lessons, :dependent => :restrict
  has_many :assignments, :dependent => :restrict

  validates :course_id, :presence => true
  validates :name, :length => { :minimum => 2 }, 
                   :uniqueness => { :scope => :course_id }

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
