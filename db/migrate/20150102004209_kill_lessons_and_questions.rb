class KillLessonsAndQuestions < ActiveRecord::Migration
  def up
    drop_table :lessons
    drop_table :questions
    drop_table :answers

    add_column :chapters, :notes, :text, null: false, default: ""
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
