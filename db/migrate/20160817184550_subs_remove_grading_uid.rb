class SubsRemoveGradingUid < ActiveRecord::Migration
  def change
    remove_index :submissions, :grading_uid
    remove_column :submissions, :grading_uid
  end
end
