class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :lesson_id, :question, :video

  belongs_to :lesson
  has_many :answers

  validates :lesson_id, :presence => true
  
  delegate :course, :to => :lesson

  before_validation do
    unless video.nil?
      video.sub! /width="\d+"/, 'width="1120"'
      video.sub! /height="\d+"/, 'height="630"'
    end
  end
end
