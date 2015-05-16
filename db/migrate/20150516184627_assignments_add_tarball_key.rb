class AssignmentsAddTarballKey < ActiveRecord::Migration
  def change
    add_column :assignments, :tar_key, :string
  end
end
