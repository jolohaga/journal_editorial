class CreateObservations < ActiveRecord::Migration
  def self.up
    create_table :observations do |t|
      t.integer  :observable_id
      t.string   :observable_type
      t.string   :action
      t.text     :what_changed
      t.integer  :user_id
      t.integer  :submission_id
      t.timestamps
    end
    add_index :observations, [:observable_type,:observable_id]
    add_index :observations, :action
    add_index :observations, :submission_id
    add_index :observations, :user_id
    add_index :observations, :created_at
    add_index :observations, :updated_at
  end

  def self.down
    drop_table :observations
  end
end
