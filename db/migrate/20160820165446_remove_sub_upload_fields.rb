class RemoveSubUploadFields < ActiveRecord::Migration
  def change
    remove_column :submissions, :secret_dir
    remove_column :submissions, :file_name
  end
end
