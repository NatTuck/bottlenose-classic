class AddCourseFooter < ActiveRecord::Migration
  def change
    add_column :courses, :footer, :text
  end
end
