class CreateLessonViews < ActiveRecord::Migration
  def change
    create_table :lesson_views do |t|
      t.integer :lesson_id
      t.integer :registration_id
      t.date :viewed_page
      t.date :viewed_video
      t.date :viewed_video2

      t.timestamps
    end
  end
end
