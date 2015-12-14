class AllowNullChapter < ActiveRecord::Migration
  def change
    Assignment.all.each do |aa|
      aa.course_id = aa.course.id
      aa.save!
    end

    change_column :assignments, :chapter_id, :integer, :null => true
    change_column :assignments, :course_id,  :integer, :null => false
  end
end
