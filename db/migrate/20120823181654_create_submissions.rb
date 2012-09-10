class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :assignment_id, :null => false
      t.integer :user_id,       :null => false
      t.string  :secret_dir
      t.string  :file_name
      t.integer :raw_score
      t.text    :student_notes

      # Teacher Grades
      t.integer :teacher_score
      t.text    :teacher_notes

      # Grading process
      t.integer :grading_uid
      t.text    :grading_output

      t.timestamps
    end

    add_index :submissions, [:assignment_id]
    add_index :submissions, [:user_id]
    add_index :submissions, [:grading_uid], :unique => true
  end
end
