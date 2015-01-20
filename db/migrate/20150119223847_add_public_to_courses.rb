class AddPublicToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :public, :boolean, default: false, null: false
  end
end
