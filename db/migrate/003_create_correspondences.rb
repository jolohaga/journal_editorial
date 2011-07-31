class CreateCorrespondences < ActiveRecord::Migration
  def self.up
    create_table :correspondences do |t|
      t.string   :server
      t.string   :uid
      t.string   :to
      t.string   :from
      t.string   :cc
      t.string   :subject
      t.text     :body
      t.string   :error_status
      t.boolean  :hidden, :default => false
      t.datetime :submitted_at
      t.string   :flags
      t.timestamps
    end
    add_index :correspondences, :uid
    add_index :correspondences, :subject
    add_index :correspondences, :from
    add_index :correspondences, :submitted_at
    add_index :correspondences, :created_at
  end

  def self.down
    drop_table :correspondences
  end
end