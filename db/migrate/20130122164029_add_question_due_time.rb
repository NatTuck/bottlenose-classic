class AddQuestionDueTime < ActiveRecord::Migration
  def up
    add_column :courses, :questions_due_time, :time
  end

  def down
    remove_column :courses, :questions_due_time 
  end
end
