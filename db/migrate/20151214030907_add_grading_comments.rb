class AddGradingComments < ActiveRecord::Migration
  def change
    add_column :submissions, :comments_upload_id, :integer
  end
end
