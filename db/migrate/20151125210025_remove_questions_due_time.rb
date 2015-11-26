class RemoveQuestionsDueTime < ActiveRecord::Migration
  def change
    remove_column :courses, :questions_due_time
  end
end
