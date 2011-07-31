class SpecializationsUsers < ActiveRecord::Migration
  def self.up
    create_table :specializations_users, :id => false do |t|
      t.integer :specialization_id
      t.integer :user_id
    end
    add_index :specializations_users, [:specialization_id, :user_id], :unique => true
  end

  def self.down
    drop_table :specializations_users
  end
end
