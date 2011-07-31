if defined?(ActiveRecord)
  # Turn off timestamped migration names
  ActiveRecord::Base.timestamped_migrations = false
end