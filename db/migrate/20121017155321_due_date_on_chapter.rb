class DueDateOnChapter < ActiveRecord::Migration
  def up
    add_column :chapters, :questions_due, :date
    remove_column :questions, :due_date
  end

  def down
    remove_column :chapters, :questions_due
    add_column :questions, :due_date, :date
  end
end
