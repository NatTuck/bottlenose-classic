class RemoveAuthKeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :auth_key
  end
end
