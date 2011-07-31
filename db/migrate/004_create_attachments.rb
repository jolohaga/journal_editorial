class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer  :correspondence_id
      t.string   :submitted_file_file_name
      t.string   :submitted_file_content_type
      t.integer  :submitted_file_file_size
      t.datetime :submitted_file_updated_at
      t.timestamps
    end
    add_index :attachments, :correspondence_id
    add_index :attachments, :submitted_file_file_name
  end

  def self.down
    drop_table :attachments
  end
end
