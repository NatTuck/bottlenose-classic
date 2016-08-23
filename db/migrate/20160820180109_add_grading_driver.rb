class AddGradingDriver < ActiveRecord::Migration
  def change
    add_column :assignments, :grading_driver, :string, default: "default.rb"
    add_column :assignments, :grading_image,  :string, default: "bn-base"
  end
end
