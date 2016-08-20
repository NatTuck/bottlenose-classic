class CreateGradingJobs < ActiveRecord::Migration
  def change
    create_table :grading_jobs do |t|
      t.integer :submission_id
      t.timestamp :started_at

      t.timestamps null: false
    end
  end
end
