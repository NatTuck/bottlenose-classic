class TeamColumns < ActiveRecord::Migration
  def change
    add_column :courses,     :team_min, :integer
    add_column :courses,     :team_max, :integer
    add_column :submissions, :team_id, :integer
    add_column :buckets,     :team_subs, :boolean
    add_column :assignments, :team_subs, :boolean
  end
end
