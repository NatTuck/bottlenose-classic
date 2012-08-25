class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :auth_key
      t.boolean :site_admin
      
      t.timestamps
    end
  end
end
