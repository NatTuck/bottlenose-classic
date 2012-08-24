class Answer < ActiveRecord::Base
  attr_accessible :answer, :question_id, :registration_id
end
