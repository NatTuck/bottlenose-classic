class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :assignment_id, :null => false
      t.integer :user_id,       :null => false
      t.string  :url
      t.text    :student_notes
      t.integer :raw_score

      t.timestamps
    end

    add_index :submissions, [:assignment_id]
    add_index :submissions, [:user_id]
  end
end
