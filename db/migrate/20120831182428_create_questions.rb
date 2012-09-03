class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :lesson_id, :null => false
      t.text :question
      t.string :correct_answer
      t.text :video

      t.timestamps
    end

    add_index :questions, [:lesson_id]
  end
end
