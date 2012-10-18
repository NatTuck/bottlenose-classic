class AddLessonNotes < ActiveRecord::Migration
  def up
    add_column :lessons, :notes, :text
  end

  def down
    remove_column :lessons, :notes
  end
end
