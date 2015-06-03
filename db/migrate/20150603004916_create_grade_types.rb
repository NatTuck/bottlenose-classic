class CreateGradeTypes < ActiveRecord::Migration
  def change
    create_table :grade_types do |t|
      t.integer :course_id
      t.string :name
      t.float :weight

      t.timestamps null: false
    end

    add_column :assignments, :grade_type_id, :integer
    add_column :assignments, :course_id, :integer

    Course.all.each do |cc|
      gt = GradeType.create(name: "Assignment", weight: 1.0, course_id: cc.id)

      cc.assignments.each do |aa|
        aa.course_id = cc.id
        aa.grade_type_id = gt.id
        aa.save!
      end
    end
  end
end
