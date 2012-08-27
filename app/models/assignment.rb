class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id

  validates :name, :uniqueness => { :scope => :chapter_id }
end
