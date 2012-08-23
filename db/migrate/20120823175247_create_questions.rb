class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :lesson_id
      t.text :text
      t.text :form

      t.timestamps
    end
  end
end
