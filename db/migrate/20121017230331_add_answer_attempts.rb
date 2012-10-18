class AddAnswerAttempts < ActiveRecord::Migration
  def up
    add_column :answers, :attempts, :integer
  end

  def down
    remove_column :answers, :attempts
  end
end
