module DashboardHelper
  def observed_header_display(record)
    case record.observable.class.name
      when "Assignment"
        "#{record.observable.submission.slug_display} Assignment"
      when "Comment"
        "#{commentable_display(record)} #{record.observable.commentable.class.name} Comment"
      when "Document"
        "#{record.observable.folder.submission.slug_display} Document"
      when "Folder"
        "#{record.observable.submission.slug_display} Folder"
      when "State"
        "#{record.observable.stateful_entity.slug_display} State"
      when "Submission"
        "#{record.observable.slug_display} Submission"
    end
  end
  
  def observed_action_display(record)
    case record.observable.class.name
    when 'Assignment'
      "#{record.action}"
    when 'Comment'
      "#{record.action}"
    when 'Document'
      "#{record.action}"
    when 'Folder'
      "#{record.action}"
    when 'State'
      "#{record.action}"
    when 'Submission'
      "#{record.action}"
    end
  end
  
  def observed_committer_display(record)
    unless record.committer.nil?
      record.committer.name
    else
      ''
    end
  end
  
  def observed_url_to(record)
    case record.observable.class.name
    when 'Assignment'
      submission_assignments_path(record.observable.submission)
    when 'Comment'
      comment_path(record.observable)
    when 'Document'
      folder_path(record.observable.folder)
    when 'Folder'
      folder_path(record.observable)
    when 'State'
      submission_states_path(record.observable.stateful_entity)
    when 'Submission'
      submission_path(record.observable)
    end
  end
  
  def commentable_display(record)
    case record.observable.commentable.class.name
    when 'Submission'
      "#{record.observable.commentable.cached_slug}".upcase
    when 'Folder'
      "#{record.observable.commentable.submission.cached_slug}".upcase
    when 'Document'
      "#{record.observable.commentable.folder.submission.cached_slug}".upcase
    end
  end
end