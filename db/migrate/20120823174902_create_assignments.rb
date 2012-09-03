class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :chapter_id, :null => false
      t.string  :name,       :null => false
      t.string :url

      t.timestamps
    end

    add_index :assignments, [:chapter_id]
  end
end
