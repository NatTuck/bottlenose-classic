class RedoScoreCaches < ActiveRecord::Migration
  def change
    add_column :chapters, :score_weight, :float

    # Remove old cache.
    remove_column :registrations, :assign_score, :string
    remove_column :registrations, :questions_score, :string

    # Correctly name auto_score.
    rename_column :submissions, :raw_score, :auto_score

    # Move everything to floats.
    reversible do |dir|
      dir.up do
        change_column :submissions, :auto_score, :float
        change_column :submissions, :teacher_score, :float
      end
      dir.down do
        change_column :submissions, :auto_score, :int
        change_column :submissions, :teacher_score, :int
      end
    end

    create_table :best_subs do |t|
      t.integer :registration_id, null: false
      t.integer :assignment_id,   null: false
      t.integer :submission_id,   null: false
      t.float   :score,           null: false
    end

    Assignment.all do |aa|
      aa.update_best_subs!
    end
  end
end
