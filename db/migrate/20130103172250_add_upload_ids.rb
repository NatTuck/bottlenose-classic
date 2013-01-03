class AddUploadIds < ActiveRecord::Migration
  def up
    add_column :submissions, :upload_id, :integer
    add_column :assignments, :assignment_upload_id, :integer
    add_column :assignments, :grading_upload_id, :integer
  end

  def down
    remove_column :submissions, :upload_id
    remove_column :assignments, :assignment_upload_id
    remove_column :assignments, :grading_upload_id
  end
end
