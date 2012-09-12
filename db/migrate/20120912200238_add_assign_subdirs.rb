class AddAssignSubdirs < ActiveRecord::Migration
  def up
    add_column :assignments, :secret_dir, :string
    execute "update assignments set secret_dir = '' where secret_dir is null"
  end

  def down
    remove_column :assignments, :secret_dir
  end
end
