class TeamUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :team_set

  validates :user, uniqueness: { 
    scope: :team_set, message: "can't be on multiple teams." }

  before_save do
    self.team_set_id = team.team_set_id
  end
end
