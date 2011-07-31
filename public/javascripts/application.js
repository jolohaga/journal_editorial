/**
 * Convert number of bytes into human readable format
 *
 * @param integer bytes     Number of bytes to convert
 * @param integer precision Number of digits after the decimal separator
 * @return string
 */
function bytesToSize(bytes, precision) {	
	var kilobyte = 1024;
	var megabyte = kilobyte * 1024;
	var gigabyte = megabyte * 1024;
	var terabyte = gigabyte * 1024;
	
	if ((bytes >= 0) && (bytes < kilobyte)) {
		return bytes + ' B';
	
	} else if ((bytes >= kilobyte) && (bytes < megabyte)) {
		return (bytes / kilobyte).toFixed(precision) + ' KB';
	
	} else if ((bytes >= megabyte) && (bytes < gigabyte)) {
		return (bytes / megabyte).toFixed(precision) + ' MB';
	
	} else if ((bytes >= gigabyte) && (bytes < terabyte)) {
		return (bytes / gigabyte).toFixed(precision) + ' GB';
	
	} else if (bytes >= terabyte) {
		return (bytes / terabyte).toFixed(precision) + ' TB';
		
	} else {
		return bytes + ' B';
	}
}

function selected_files() {
  var html = '<table><caption class="header">Selected for uploading</caption>';
  html += '<tr><td class="header">Name</td><td class="header center-align">Size</td></tr>';
  for (var i = 0; i < $('#upload_data_')[0].files.length; i++) {
    html += '<tr>';
    html += '<td>' + $('#upload_data_')[0].files[i].name + '</td><td class="right-align">' + bytesToSize($('#upload_data_')[0].files[i].size,2) + '</td>';
    html += '</tr>';
      //$('#upload_data_')[0].files[i].name));
  }
  html += '</html>';
  $('#selected-files').html(html);
}

function toggle_abstract() {
  $('#abstract').toggle('blind');
  $('#abstract_control').html($('#abstract_control').html() == 'Show' ? 'Hide' : 'Show');
}

function toggle_form_letter_body() {
  $('#form_letter_body').toggle('blind');
  $('#form_letter_body_control').html($('#form_letter_body_control').html() == 'Show' ? 'Hide' : 'Show');
}

function toggle_adoptor_selection() {
  if ($('#state_state').val() == 'Orphan') {
    $('#adoptor_selection').hide();
  } else {
    $('#adoptor_selection').show();
  }
}

function toggle_at_a_glance_buttons_and_views(selected) {
  if (selected == 'outstanding') {
    $('#recent_button').css('font-weight', 'normal');
    $('#recent').hide();
    $('#adoption_button').css('font-weight', 'normal');
    $('#adoption').hide();
    $('#outstanding_button').css('font-weight', 'bold');
    $('#outstanding').show();
    $.cookie('at_a_glance_selected', 'outstanding', { path: '/' });
  } else if (selected == 'recent') {
    $('#outstanding_button').css('font-weight', 'normal');
    $('#outstanding').hide();
    $('#adoption_button').css('font-weight', 'normal');
    $('#adoption').hide();
    $('#recent_button').css('font-weight', 'bold');
    $('#recent').show();
    $.cookie('at_a_glance_selected', 'recent', { path: '/' });
  } else if (selected == 'adoption') {
    $('#recent_button').css('font-weight', 'normal');
    $('#recent').hide();
    $('#outstanding_button').css('font-weight', 'normal');
    $('#outstanding').hide();
    $('#adoption_button').css('font-weight', 'bold');
    $('#adoption').show();
    $.cookie('at_a_glance_selected', 'adoption', { path: '/' });
  }
}

function set_at_a_glance() {
  if (document.location.pathname == "/") {
    if ($.cookie('at_a_glance_selected') == 'recent') {
      toggle_at_a_glance_buttons_and_views('recent');
    } else if ($.cookie('at_a_glance_selected') == 'adoption') {
      toggle_at_a_glance_buttons_and_views('adoption');
    } else {
      toggle_at_a_glance_buttons_and_views('outstanding');
    }
  }
}

function toggle_assignments_buttons_and_views(selected) {
  if (selected == 'active') {
    $('#active_assignments_button').css('font-weight', 'bold');
    $('#active_assignments').show();
    $('#published_assignments_button').css('font-weight', 'normal');
    $('#published_assignments').hide();
    $('#removed_assignments_button').css('font-weight', 'normal');
    $('#removed_assignments').hide();
  } else if (selected == 'published') {
    $('#active_assignments_button').css('font-weight', 'normal');
    $('#active_assignments').hide();
    $('#published_assignments_button').css('font-weight', 'bold');
    $('#published_assignments').show();
    $('#removed_assignments_button').css('font-weight', 'normal');
    $('#removed_assignments').hide();
  } else if (selected == 'rejected') {
    $('#active_assignments_button').css('font-weight', 'normal');
    $('#active_assignments').hide();
    $('#published_assignments_button').css('font-weight', 'normal');
    $('#published_assignments').hide();
    $('#removed_assignments_button').css('font-weight', 'bold');
    $('#removed_assignments').show();
  }
}

function load_expertise_auto_completion() {
  if (typeof expertise == 'object') {
    $('#expertise_search_field').autocomplete({
      source: expertise
    });
    $('#expertise_search_field').focus();
  }
  
}

$(function() {
  load_expertise_auto_completion();
  $('#active_assignments_button').click(function() {
    toggle_assignments_buttons_and_views('active');
  });
  $('#published_assignments_button').click(function() {
    toggle_assignments_buttons_and_views('published');
  });
  $('#removed_assignments_button').click(function() {
    toggle_assignments_buttons_and_views('rejected');
  });
  $('#submission_search_field').focus();
  set_at_a_glance();
  $('#outstanding_button').click(function() {
    toggle_at_a_glance_buttons_and_views('outstanding');
  });
  $('#recent_button').click(function() {
    toggle_at_a_glance_buttons_and_views('recent');
  });
  $('#adoption_button').click(function() {
    toggle_at_a_glance_buttons_and_views('adoption');
  });
  $('#state_state').change(function() {
    toggle_adoptor_selection();
  });
  $('#folder_activity').change(function() {
    $('#folder_attempt').val(next_folder_assignment_numbers[$('#folder_activity option:selected').val()]);
  });
  $('#upload_data_').change(function() {
    selected_files();
  });
  $('#filter').change(function() {
    window.location.replace(location.pathname+"?filter_by="+$("#filter").val());
  });
  $('#abstract_control').click(function() {
    toggle_abstract();
    return false;
  });
  $('#form_letter_body_control').click(function() {
    toggle_form_letter_body();
    return false;
  });
  if ($('#state_recorded_at').length) {
    $("#state_recorded_at").datepicker({dateFormat: 'yy-mm-dd', minDate: min_date, maxDate: max_date, changeMonth: true, changeYear: true});
  }
});