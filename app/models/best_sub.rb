class BestSub < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  belongs_to :assignment
  
  validates :assignment_id, :uniqueness => { :scope => :user_id }
  validates :user_id, :uniqueness => { :scope => :assignment_id }
end
