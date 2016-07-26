class TeamSet < ActiveRecord::Base
  belongs_to :course
  has_many :teams
  has_many :team_users

  validates_presence_of :name
  validates_presence_of :course_id

  validates :name, uniqueness: { scope: :course_id }

  def self.create_solo!(course)
    ts = TeamSet.new
    ts.course_id = course.id
    ts.name = "Solo"
    ts.save!
  end

  def self.update_solo!(course)
    solo = TeamSet.where(name: "Solo", course_id: course.id).first
    solo.extra_students.each do |uu|
      tt = Team.new(course: course, team_set: solo)
      tt.users = [uu]
      tt.save!
    end
  end

  def team_for(user)
    TeamUser.where(team_set: self, user: user).first.team
  end

  def extra_students
    on_teams = team_users.map {|tu| tu.user }
    course.students - on_teams
  end

  def make_teacher_team!
    on_teams = team_users.map {|tu| tu.user }
    members = course.teachers - on_teams
    tt = Team.new(team_set: self, course: course)
    tt.users = members
    tt.save!

    tt
  end
end
