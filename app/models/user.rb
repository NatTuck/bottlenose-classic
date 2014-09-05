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
  
  # Different people with the same name are fine.
  # If someone uses two emails, they get two accounts. So sad.
  #validates :name,  :uniqueness => true

  before_validation do
    if self.auth_key.nil?
      self.auth_key = SecureRandom.urlsafe_base64
    end

    unless self.email.nil?
      self.email = self.email.downcase
    end
  end

  def guest?
    false
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

  def registration_for(course)
    Registration.find_by_user_id_and_course_id(self.id, course.id)
  end
end
