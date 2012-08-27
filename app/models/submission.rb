class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :registration_id, :url, :student_notes, :score 


end
