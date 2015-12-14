class AllowNullChapter < ActiveRecord::Migration
  def change
    change_column :assignments, :chapter_id, :integer, :null => true
    change_column :assignments, :course_id,  :integer, :null => false
  end
end
