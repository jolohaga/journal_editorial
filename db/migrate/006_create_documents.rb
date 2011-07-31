class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer  :folder_id
      t.string   :assignment_number
      t.string   :working_file_file_name
      t.string   :working_file_content_type
      t.integer  :working_file_file_size
      t.timestamps
    end
    add_index :documents, :folder_id
    add_index :documents, :assignment_number
    add_index :documents, :working_file_file_name
  end

  def self.down
    drop_table :documents
  end
end
