class Document < ActiveRecord::Base
  belongs_to :folder
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :observations, :as => :observable, :dependent => :destroy
  
  has_attached_file :working_file, :path => ':rails_root/attached_files/:attachment/:id/:style/:filename'
  
  def slug_display
    # To do: Fill this in.
  end
  
  def submission
    folder.submission
  end
end