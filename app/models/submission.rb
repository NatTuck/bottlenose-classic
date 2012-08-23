class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :good, :registration_id, :status, :url
end
