class AddLateOptions < ActiveRecord::Migration
  def up
    add_column :courses, :late_options, :string, :default => "10,1,0"
  end

  def down
    remove_column :courses, :late_options
  end
end
