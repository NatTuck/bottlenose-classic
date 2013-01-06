class AddAssignmentBlame < ActiveRecord::Migration
  def up
    add_column :assignments, :blame_id, :integer

    Assignment.all.each do |assn|
      if assn.blame_id.nil?
        assn.blame_id = assn.course.first_teacher
        assn.save!
      end
    end
  end

  def down
    remove_column :assignments, :blame_id 
  end
end
