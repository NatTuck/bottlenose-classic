class AddQuestionsScoreCache < ActiveRecord::Migration
  def up
    add_column :registrations, :questions_score, :string
  end

  def down
    remove_column :registrations, :questions_score
  end
end
