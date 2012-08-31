class Answer < ActiveRecord::Base
  attr_accessible :answer, :lesson_id, :registration_id

  belongs_to :lesson
  belongs_to :registration

  delegate :user,           :to => :registration, :allow_nil => false
  delegate :user_id,        :to => :registration, :allow_nil => false
  delegate :correct_answer, :to => :lesson,       :allow_nil => false

  validates :lesson_id,       :presence => true
  validates :registration_id, :presence => true

  def score
    if answer == correct_answer
      100
    else
      0
    end
  end
end
