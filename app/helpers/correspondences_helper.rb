module CorrespondencesHelper
  def toggle_hide_label
    if params[:action] == 'hidden_correspondences'
      'Unhide'
    else
      'Hide'
    end
  end
  
  def back_to_correspondences
    link_to_if(@correspondences.hidden?, 'Submissions', hidden_correspondences_path(:page => session[:last_hidden_correspondences_page])) do
      link_to_unless(@submission.hidden?, 'Submissions', correspondences_path(:page => session[:last_unhidden_correspondences_page]))
    end
  end
  
  def correspondences_navigation
    content_tag :p do
      link_to_unless_current('Unhidden', correspondences_path(:page => session[:last_unhidden_correspondences_page]), :class => 'header-link') +
      " | " +
      link_to_unless_current('Hidden', hidden_correspondences_path(:page => session[:last_hidden_correspondences_page]), :class => 'header-link')
    end
  end
  
  def correspondences_filters
    content_tag :p do
      'Include: ' +
      check_box_tag('hidden') + ' hidden ' +
      check_box_tag('no attachments') + ' without attachments ' +
      check_box_tag('with errors') + ' with errors'
    end
  end
end