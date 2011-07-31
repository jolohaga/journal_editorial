class CreateFormLetters < ActiveRecord::Migration
  def self.up
    create_table :form_letters do |t|
      t.string :name
      t.string :default_from
      t.string :default_reply_to
      t.string :default_recipients
      t.string :default_cc_recipients
      t.string :default_bcc_recipients
      t.string :subject
      t.text   :body
      t.text   :signature
      t.string :notifiable_type
      t.string :cached_slug
      t.timestamps
    end
    add_index :form_letters, :cached_slug
    add_index :form_letters, :notifiable_type
  end

  def self.down
    drop_table :form_letters
  end
end
