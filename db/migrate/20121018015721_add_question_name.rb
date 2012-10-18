class AddQuestionName < ActiveRecord::Migration
  def up
    add_column :questions, :name, :string
  end

  def down
    remove_column :questions, :name
  end
end
