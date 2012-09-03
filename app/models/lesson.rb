class Lesson < ActiveRecord::Base
  attr_accessible :chapter_id, :name, :question, :correct_answer, :video

  belongs_to :chapter
  has_many :questions

  validates :chapter_id, :presence => true
  validates :name,       :length => { :minimum => 2 },
                         :uniqueness => { :scope => :chapter_id }

  delegate :course, :to => :chapter

  before_validation do
    unless video.nil?
      video.sub! /width="\d+"/, 'width="1120"'
      video.sub! /height="\d+"/, 'height="630"'
    end
  end
end
