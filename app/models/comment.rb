class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many :observations, :as => :observable, :dependent => :destroy
  
  FOLDER_COMMENTS = ["Author's submission", "Editor's submission" ]
  
  def submission
    commentable.submission
  end
end