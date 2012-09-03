class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string  :name,      :null => false
      t.integer :course_id, :null => false

      t.timestamps
    end

    add_index :chapters, [:course_id]
  end
end
