class Assignment < ActiveRecord::Base
  attr_accessible :name, :chapter_id

  belongs_to :chapter
  has_many :submisisons

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true

  delegate :course, :to => :chapter
end
