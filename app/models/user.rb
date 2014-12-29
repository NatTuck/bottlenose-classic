require 'securerandom'

class User < ActiveRecord::Base
  has_many :registrations
  has_many :courses, :through => :registrations, :dependent => :restrict_with_error
  
  has_many :answers,     :dependent => :restrict_with_error
  has_many :submissions, :dependent => :restrict_with_error

  validates :email, :format => { :with => /\@.*\./ }
  validates :auth_key, :presence => true

  validates :email, uniqueness: true
  validates :name,  length: { in: 2..30 } 
  
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

  def send_auth_link_email!
    if self.auth_key.nil?
      self.auth_key = SecureRandom.urlsafe_base64
      self.save!
    end
    
    AuthMailer.auth_link_email(self).deliver_later
  end

  def course_admin?(course)
    self.site_admin? or course.taught_by?(self)
  end

  def registration_for(course)
    Registration.find_by_user_id_and_course_id(self.id, course.id)
  end

  def invert_name
    name.split(/\s+/).rotate(-1).join(' ')
  end

  def reasonable_name?
    @name =~ /\s+/ and @name.downcase != @name
  end
end
