class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string   :state
      t.date     :recorded_at
      t.integer  :stateful_entity_id
      t.string   :stateful_entity_type
      t.timestamps
    end
    add_index :states, :state
    add_index :states, :recorded_at
    add_index :states, :created_at
    add_index :states, :stateful_entity_id
    add_index :states, [:stateful_entity_type, :stateful_entity_id]
  end

  def self.down
    drop_table :states
  end
end