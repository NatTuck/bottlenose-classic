class AddEndDateToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :end_date, :datetime
  end
end
