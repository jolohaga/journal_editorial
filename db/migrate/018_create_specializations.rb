class CreateSpecializations < ActiveRecord::Migration
  def self.up
    create_table :specializations do |t|
      t.string :category
      t.string :name
      t.timestamps
    end
    add_index :specializations, :category
    add_index :specializations, :name
  end

  def self.down
    drop_table :specializations
  end
end
