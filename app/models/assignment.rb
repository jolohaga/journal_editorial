class Assignment < ActiveRecord::Base
   belongs_to :user
   belongs_to :submission
   has_many :observations, :as => :observable, :dependent => :destroy

   scope :as, lambda {|role| where(["role = ?", role])}
   scope :editors, as(Role::ASSOCIATE_EDITOR)
   scope :corresponding_authors, as(Role::CORRESPONDING_AUTHOR)
   scope :reviewers, as(Role::REVIEWER)
end