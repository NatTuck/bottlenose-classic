class CreateGradeTypes < ActiveRecord::Migration
  def change
    create_table :grade_types do |t|
      t.integer :course_id
      t.string :name
      t.float :weight

      t.timestamps null: false
    end

    add_column :assignments, :grade_type_id, :integer
  end
end
