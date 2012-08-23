class Registration < ActiveRecord::Base
  attr_accessible :course_id, :teacher, :user_id
end
