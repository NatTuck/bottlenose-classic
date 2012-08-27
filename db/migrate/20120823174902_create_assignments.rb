class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :chapter_id
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
