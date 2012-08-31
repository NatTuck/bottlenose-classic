class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :chapter_id
      t.text :video
      t.text :question
      t.string :correct_answer
      t.text :video2

      t.timestamps
    end
  end
end
