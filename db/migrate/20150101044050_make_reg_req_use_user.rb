class MakeRegReqUseUser < ActiveRecord::Migration
  def change
    add_column :reg_requests, :user_id, :integer
    remove_column :reg_requests, :name, :string
    remove_column :reg_requests, :email, :string
  end
end
