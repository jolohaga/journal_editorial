module SubmissionsHelper
  def submit_label
    case action_name
    when 'new', 'create'
      'Continue'
    when 'edit', 'update'
      'Update'
    else
      ''
    end
  end
  
  def state_event_links
    case @submission.state
    when ''
    end
  end
  
  def editors_display
    @submission.editors.collect {|user| link_to(user.name, editor_path(user))}.join(', ').html_safe
  end
  
  def corresponding_authors_display
    @submission.corresponding_authors.collect {|user| user.name}.join(', ')
  end
  
  def reviewers_display
    @submission.reviewers.collect {|user| user.name}.join(', ')
  end
  
  def participant_display
    editors = editors_display
    corresponding_authors = corresponding_authors_display
    reviewers = reviewers_display
    display = ''.html_safe
    display += editors.blank? ? '' : '<em>Editors:</em> '.html_safe + editors
    display += reviewers.blank? ? '' : ('; <em>Reviewers:</em> '.html_safe + reviewers).html_safe
    display += corresponding_authors.blank? ? '' : ('; <em>Corresponding Authors:</em> '.html_safe + corresponding_authors).html_safe
  end
end