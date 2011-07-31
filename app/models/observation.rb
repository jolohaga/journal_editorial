class Observation < ActiveRecord::Base
  belongs_to :observable, :polymorphic => true
  belongs_to :submission
  belongs_to :committer, :class_name => 'User'
  
  scope :recents, where("observations.id IN (
        SELECT DISTINCT ON (o2.submission_id) o1.id
          FROM observations o1, observations o2
          WHERE o1.observable_id = o2.observable_id
          GROUP BY o1.id, o2.observable_id, o1.observable_id, o1.created_at, o2.submission_id, o2.created_at
          HAVING o1.created_at = MAX(o2.created_at)
          ORDER BY o2.submission_id, o2.created_at DESC)")
end