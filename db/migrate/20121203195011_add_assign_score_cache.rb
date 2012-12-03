class AddAssignScoreCache < ActiveRecord::Migration
  def up
    add_column :registrations, :assign_score, :string
  end

  def down
    remove_column :registrations, :assign_score
  end
end
