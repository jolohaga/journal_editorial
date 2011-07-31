namespace :journal do
  desc 'Initialize application.'
  task :initialize => :environment do
    puts "Populating roles table."
    Role::ROLES.each do |role|
      Role.find_or_create_by_name(role)
    end
    puts "Populating user table with admin user."
    user = User.find_or_create_by_name(Journal::Users::ADMIN_NAME, :username => Journal::Users::ADMIN_USERNAME, :email => Journal::Users::ADMIN_EMAIL, :password => Journal::Users::ADMIN_PASSWORD)
    puts "Assigning admin user the admin role."
    unless user.role? Role::ADMINISTRATOR
      user.roles << Role.find_or_create_by_name(Role::ADMINISTRATOR)
    end
    puts "Populating assignment_number table."
    unless AssignmentNumber.count > 0
      AssignmentNumber.create(:next_assignment_number => 600)
    end
  end
  
  desc "Report Journal editor involvement"
  task :editor_involvement => :environment do
    data = []
    missing_sign_in = []
    missing_specialization = []
    missing_active_reviews = []
    (User.editors.active.order('LOWER(last_name) ASC, LOWER(first_name) ASC').all - User.managing_editors.active).each do |u|
      data << "#{u.name}  #{u.email}  #{u.sign_in_count}  #{u.sign_in(:when => 'current')}  #{u.sign_in(:when => 'last')} #{u.specializations.length} #{u.responsibilities.active_under_review.length}  #{u.responsibilities.reviewed_and_under_publication.length} #{u.responsibilities.reviewed_and_under_removal.length}"
      missing_sign_in << u.name if u.sign_in_count == 0
      missing_active_reviews << u.name if u.responsibilities.active_under_review.length == 0
      missing_specialization << u.name if u.specializations.length == 0
    end
    puts "Journal Editor Involvement for #{Date.today}\n\n"
    puts "Never signed-in\n#{missing_sign_in.join(', ')}\n\n"
    puts "Not actively reviewing\n#{missing_active_reviews.join(', ')}\n\n"
    puts "Specializations empty\n#{missing_specialization.join(', ')}\n\n"
  end
  
  desc "Email report on submissions which are due."
  task :email_about_due_submissions => :environment do
    email_about('due')
  end
  
  desc "Email report on submissions which are overdue."
  task :email_about_overdue_submissions => :environment do
    email_about('overdue')
  end
  
  # Start: Used by email_about_* tasks
  #
  def email_about(cutoff)
    subject = ''
    # To do: DRY up cutoff condition tests in email_about and submissions.
    if cutoff == 'due'
      subject = "#{Journal::Settings::SUBMISSION_PREFIX} Submissions Due for #{Date.today}"
    elsif cutoff == 'overdue'
      subject = "#{Journal::Settings::SUBMISSION_PREFIX} Submissions Overdue for #{Date.today}"
    end
    # To do: Iterate over DEADLINES keys to dynamically create these variables.
    submitted = submissions(:state => 'submitted', :cutoff => cutoff)
    awaiting_review = submissions(:state => 'awaiting_review', :cutoff => cutoff)
    undergoing_revision = submissions(:state => 'undergoing_revision', :cutoff => cutoff)
    final_screening = submissions(:state => 'final_screening', :cutoff => cutoff)
    reviewing = submissions(:state => 'reviewing', :cutoff => cutoff)
    pending = submissions(:state => 'pending', :cutoff => cutoff)
    publishing = submissions(:state => 'publishing', :cutoff => cutoff)
    
    NotificationMailer.due_notice({:subject => subject, :body => msg_body(binding)}).deliver
  end
  
  def submissions(options)
    submissions = nil
    min = "Journal::Production.#{options[:state]}_dates[:min]"
    max = "Journal::Production.#{options[:state]}_dates[:max]"
    if options[:cutoff] == 'due'
      submissions = Submission.send(options[:state]).recorded_between(
        eval(min),
        eval(max)).order("states.recorded_at ASC, submissions.assignment_number ASC")
    elsif options[:cutoff] == 'overdue'
      submissions = Submission.send(options[:state]).recorded_before(
        eval(max)).order("states.recorded_at ASC, submissions.assignment_number ASC")
    end
    submissions
  end
  
  def msg_body(vars)
    body =<<EndOfMessage
<h4>Submitted.  #{eval('cutoff',vars).titleize} to receive acknowledgement.  Two weeks (&plusmn;1 week) from recorded date</h4>
<p>
#{submission_msg(eval('submitted',vars))}
</p>
<h4>Awaiting review.  #{eval('cutoff',vars).titleize} to be assigned/adopted.  Three months (&plusmn;1 week) from recorded date</h4>
<p>
#{submission_msg(eval('awaiting_review',vars))}
</p>
<h4>Undergoing revision.  #{eval('cutoff',vars).titleize} to be resubmitted by author.  One year (&plusmn;1 month) from recorded date</h4>
<p>
#{submission_msg(eval('undergoing_revision',vars))}
</p>
<h4>Final screening.  #{eval('cutoff',vars).titleize} to be published.  One year (&plusmn;1 month) from recorded date</h4>
<p>
#{submission_msg(eval('final_screening',vars))}
</p>
<h4>Publishing.  #{eval('cutoff',vars).titleize} to mark as published.  One year (&plusmn;1 month) from recorded date</h4>
<p>
#{submission_msg(eval('publishing',vars))}
</p>
<h4>Reviewing.  #{eval('cutoff',vars).titleize} to receive report.  Two months (&plusmn;1 week) from recorded date</h4>
<p>
#{submission_msg(eval('reviewing',vars))}
</p>
<h4>Pending.  #{eval('cutoff',vars).titleize} to confirm decision.  Two months (&plusmn;1 week) from recorded date</h4>
<p>
#{submission_msg(eval('pending',vars))}
</p>
EndOfMessage
    body
  end
  
  def submission_msg(submissions)
    msg = ''
    submissions.each do |s|
      msg << "#{s.current_state.recorded_at} &mdash; <a href='#{Journal::Settings::SUBMISSIONS_URL}#{s.friendly_id}'>#{s.slug_display}</a>: #{s.title}<br/>"
    end
    msg
  end
  #
  # End: Used by email_about_* tasks
end