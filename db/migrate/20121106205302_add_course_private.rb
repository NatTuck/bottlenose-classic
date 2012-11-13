class AddCoursePrivate < ActiveRecord::Migration
  def up
    add_column :courses, :private, :boolean
    Course.all.each do |cc|
      cc.private = true
      cc.save!
    end
  end

  def down
    remove_column :courses, :private
  end
end
