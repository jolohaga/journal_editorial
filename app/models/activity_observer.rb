class ActivityObserver < ActiveRecord::Observer
  # All activity observable models are required to define #submission
  observe :assignment, :comment, :document, :folder, :submission, :state
  
  def after_update(record)
    record.observations << create_observation_with("Updated", record) unless record.changes.blank?
  end
  
  def after_create(record)
    record.observations << create_observation_with("Created", record)
  end
  
  def create_observation_with(action, record)
    Observation.new do |ob|
      ob.action = action
      ob.what_changed = "#{record.changes}"
      ob.submission = record.submission
      ob.committer = User.current
    end
  end
end