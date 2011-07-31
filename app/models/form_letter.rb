class FormLetter < ActiveRecord::Base
  has_many :tags, :as => :taggable, :dependent => :destroy
  has_friendly_id :name, :use_slug => true
  
  NOTIFIABLE_TYPES = ['Submission', 'Folder']
end