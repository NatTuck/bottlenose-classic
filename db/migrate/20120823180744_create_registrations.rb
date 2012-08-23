class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :course_id
      t.integer :user_id
      t.boolean :teacher

      t.timestamps
    end
  end
end
