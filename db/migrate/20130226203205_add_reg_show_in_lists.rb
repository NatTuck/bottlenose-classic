class AddRegShowInLists < ActiveRecord::Migration
  def up
    add_column :registrations, :show_in_lists, :boolean

    Registration.all.each do |reg|
      if reg.teacher?
        reg.show_in_lists = false
      else
        reg.show_in_lists = true
      end

      reg.save!
    end
  end

  def down
    remove_column :registrations, :show_in_lists
  end
end
