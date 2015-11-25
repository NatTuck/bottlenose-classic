class DropChapters < ActiveRecord::Migration
  def up
    drop_table :chapters

    remove_column :assignments, :chapter_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
