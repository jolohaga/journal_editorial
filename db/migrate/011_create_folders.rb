class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.integer :submission_id
      t.integer :assignment_number
      t.string  :cached_slug
      t.string  :activity
      t.integer :attempt
      t.timestamps
    end
    add_index :folders, :submission_id
    add_index :folders, :assignment_number
    add_index :folders, :activity
    add_index :folders, :cached_slug
    add_index :folders, :created_at
  end

  def self.down
    drop_table :folders
  end
end