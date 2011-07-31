class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.string   :paper_type
      t.string   :title, :default => 'Replace with title'
      t.string   :authors, :default => 'Replace with authors'
      t.text     :abstract
      t.string   :keywords
      t.string   :assignment_number, :default => 'X'
      t.string   :cached_slug
      t.timestamps
    end
    add_index :submissions, :title
    add_index :submissions, :assignment_number
    add_index :submissions, :cached_slug
    add_index :submissions, :created_at
  end

  def self.down
    drop_table :submissions
  end
end
