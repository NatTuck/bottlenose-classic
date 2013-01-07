class MoveQuestionDueDateToLesson < ActiveRecord::Migration
  def up
    remove_column :chapters, :questions_due
    add_column    :lessons,  :questions_due, :date
  end

  def down
    remove_column :lessons,  :questions_due
    add_column    :chapters, :questions_due, :date
  end
end
