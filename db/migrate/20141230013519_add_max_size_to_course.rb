class AddMaxSizeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :sub_max_size, :integer, null: false, default: 20
  end
end
