class IgnoreLatePenalty < ActiveRecord::Migration
  def up
    add_column :submissions, :ignore_late_penalty, :boolean, :default => false
  end

  def down
    remove_column :submissions, :ignore_late_penalty
  end
end
