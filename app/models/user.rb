require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :site_admin, :auth_key

  has_many :registrations
  has_many :courses, :through => :registrations, :dependent => :restrict
  
  has_many :answers,     :dependent => :restrict
  has_many :submissions, :dependent => :restrict

  validates :email, :format => { :with => /\@.*\./ }
  validates :name,  :length => { :minimum => 2 }
  validates :auth_key, :presence => true

  validates :email, :uniqueness => true
  validates :name,  :uniqueness => true

  before_validation do
    if self.auth_key.nil?
      self.auth_key = SecureRandom.urlsafe_base64
    end
  end
  
  def send_auth_link_email!(base_url)
    if self.auth_key.nil?
      self.auth_key = SecureRandom.urlsafe_base64
      self.save!
    end
    
    AuthMailer.auth_link_email(self, base_url).deliver
  end

  def course_admin?(course)
    self.site_admin? or course.taught_by?(self)
  end
end
