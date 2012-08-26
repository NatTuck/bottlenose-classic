require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :site_admin, :auth_key

  has_many :registrations
  has_many :courses, :through => :registrations

  validates :email, :format => { :with => /\@.*\./ }
  validates :name,  :length => { :minimum => 2 }
  
  def send_auth_link_email!(base_url)
    if self.auth_key.nil?
      self.auth_key = SecureRandom.urlsafe_base64
      self.save!
    end
    
    AuthMailer.auth_link_email(self, base_url).deliver
  end
end
