class FiveMegDefault < ActiveRecord::Migration
  def change
    change_column_default(:courses, :sub_max_size, 5)
  end
end
