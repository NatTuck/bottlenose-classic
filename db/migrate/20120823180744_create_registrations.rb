class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :course_id, :null => false
      t.integer :user_id,   :null => false
      t.boolean :teacher

      t.timestamps
    end

    add_index :registrations, [:course_id]
    add_index :registrations, [:user_id]
  end
end
