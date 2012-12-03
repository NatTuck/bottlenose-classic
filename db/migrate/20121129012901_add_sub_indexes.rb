class AddSubIndexes < ActiveRecord::Migration
  def up
    add_index :submissions, [:user_id, :assignment_id]
  end

  def down
  end
end
