class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :user_id
      t.string  :file_name
      t.string  :secret_key
      t.timestamps
    end

    add_index :uploads, [:secret_key], :unique => true
  end
end
