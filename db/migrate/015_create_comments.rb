class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.string  :commentable_type
      t.integer :user_id
      t.text    :comment
      t.timestamps
    end
    add_index :comments, [:commentable_type,:commentable_id]
  end

  def self.down
    drop_table :comments
  end
end
