class AddSizeToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :upload_size, :integer, null: false, default: 0
  end
end
