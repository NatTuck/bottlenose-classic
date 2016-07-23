class CreateTeamSets < ActiveRecord::Migration
  def change
    create_table :team_sets do |t|
      t.string :name
      t.integer :course_id

      t.timestamps null: false
    end

    add_column :teams, :team_set_id, :integer

    add_column :assignments, :team_set_id, :integer
    remove_column :assignments, :team_subs, :boolean

  end
end
