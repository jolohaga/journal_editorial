class Attachment < ActiveRecord::Base
  belongs_to :correspondence
  has_attached_file :submitted_file, :path => ':rails_root/attached_files/:attachment/:id/:style/:filename'
end