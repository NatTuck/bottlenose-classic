class AddSolutionFile < ActiveRecord::Migration
  def up
    add_column :assignments, :solution_upload_id, :integer
  end

  def down
    remove_column :assignments, :solution_upload_id
  end
end
