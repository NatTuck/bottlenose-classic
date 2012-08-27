class Lesson < ActiveRecord::Base
  attr_accessible :chapter_id, :name, :question_id, :video, :video2

  belongs_to :chapter

  validates :chapter_id, :presence => true
  validates :name,       :length => { :minimum => 2 }
end
