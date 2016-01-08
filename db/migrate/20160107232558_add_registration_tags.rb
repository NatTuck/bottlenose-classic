class AddRegistrationTags < ActiveRecord::Migration
  def change
    add_column :registrations, :tags, :string, default: ""
  end
end
