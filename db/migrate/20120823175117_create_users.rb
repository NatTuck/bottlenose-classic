class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,     :null => false
      t.string :email,    :null => false
      t.string :auth_key, :null => false
      t.boolean :site_admin

      t.timestamps
    end

    add_index :users, [:email], :unique => true
  end
end
