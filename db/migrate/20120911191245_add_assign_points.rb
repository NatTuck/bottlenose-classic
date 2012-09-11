class AddAssignPoints < ActiveRecord::Migration
  def up
    add_column :assignments, :points_available, :integer, :default => 100
  end

  def down
    remove_column :assignments, :points_available
  end
end
