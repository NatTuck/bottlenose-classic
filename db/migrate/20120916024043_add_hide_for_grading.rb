class AddHideForGrading < ActiveRecord::Migration
  def up
    add_column :assignments, :hide_grading, :boolean, :default => false
  end

  def down
    remove_column :assignments, :hide_grading
  end
end
