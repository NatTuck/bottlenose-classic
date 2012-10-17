class SplitQuestionForm < ActiveRecord::Migration
  def up
    rename_column :questions, :video, :explanation
    add_column :questions, :question_form, :text
  end

  def down
    rename_column :questions, :explanation, :video
    remove_column :questions, :question_form
  end
end
