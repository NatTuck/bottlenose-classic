class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string  :name
      t.boolean :archived, :default => false

      t.timestamps
    end

    add_column :courses, :term_id, :integer
  end
end
