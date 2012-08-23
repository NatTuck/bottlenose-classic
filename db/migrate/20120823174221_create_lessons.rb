class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :course_id
      t.string :video
      t.string :video2
      t.integer :question_id

      t.timestamps
    end
  end
end
