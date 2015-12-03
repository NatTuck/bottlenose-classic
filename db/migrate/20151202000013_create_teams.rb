class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :course_id
      t.date :start_date

      t.timestamps null: false
    end
  end
end
