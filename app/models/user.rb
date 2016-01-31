require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :registrations
  has_many :courses, through: :registrations, :dependent => :restrict_with_error

  has_many :submissions,  dependent: :restrict_with_error
  has_many :reg_requests, dependent: :destroy

  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users, dependent: :destroy

  validates :email, :format => { :with => /\@.*\./ }

  validates :email, uniqueness: true
  validates :name,  length: { in: 2..30 }

  # Different people with the same name are fine.
  # If someone uses two emails, they get two accounts. So sad.
  #validates :name,  :uniqueness => true

  def ldap_before_save
    self.name = Devise::LDAP::Adapter.get_ldap_param(self.email, "displayname").first
  end

  before_validation do
    unless self.email.nil?
      self.email = self.email.downcase
      self.email = self.email.strip
      self.email.sub!(/\W$/, '')
    end
  end

  def to_s
    self.email
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

  def surname
    invert_name.split(/\s+/).first
  end

  def dir_name
    invert_name.gsub(/\W/, '_')
  end

  def reasonable_name?
    name =~ /\s/ && name.downcase != name
  end

  def active_team(course)
    teams = Team.joins(:team_users).where("team_users.user_id = ?", self.id).
      where("course_id = ?", course.id).where("start_date <= now()").order(:start_date)
    if teams.size > 0
      teams.first
    else
      nil
    end
  end
end
