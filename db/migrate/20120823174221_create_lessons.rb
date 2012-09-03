class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string  :name,       :null => false
      t.integer :chapter_id, :null => false
      t.text    :video

      t.timestamps
    end

    add_index :lessons, [:chapter_id]
  end
end
