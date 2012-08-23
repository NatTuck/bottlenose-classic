class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :assignment_id
      t.integer :registration_id
      t.string :url
      t.integer :score
      t.text :status

      t.timestamps
    end
  end
end
