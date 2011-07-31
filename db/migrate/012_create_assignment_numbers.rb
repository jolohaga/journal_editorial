class CreateAssignmentNumbers < ActiveRecord::Migration
  def self.up
    create_table :assignment_numbers do |t|
      t.integer :next_assignment_number
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_numbers
  end
end
