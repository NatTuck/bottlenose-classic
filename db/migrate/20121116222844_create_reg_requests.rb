class CreateRegRequests < ActiveRecord::Migration
  def change
    create_table :reg_requests do |t|
      t.integer :course_id
      t.string  :name
      t.string  :email
      t.text    :notes

      t.timestamps
    end
  end
end
