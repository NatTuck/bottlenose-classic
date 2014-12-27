class RemoveGuests < ActiveRecord::Migration
  def change
    remove_column :courses, :private, :boolean
  end
end
