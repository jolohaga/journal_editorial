class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :submission_id
      t.integer :user_id
      t.string  :role
      t.timestamps
    end
    add_index :assignments, :submission_id
    add_index :assignments, :user_id
  end

  def self.down
    drop_table :assignments
  end
end
