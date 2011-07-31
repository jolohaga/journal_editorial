class NotificationMailer < ActionMailer::Base
  def notify(options)
    to = options[:to]
    cc = options[:cc]
    bcc = options[:bcc]
    reply_to = options[:reply_to]
    subject = options[:subject]
    from = options[:from]
    @message = options[:body]
    mail(:to => to,
         :cc => cc,
         :bcc => bcc,
         :reply_to => reply_to,
         :subject => subject,
         :from => from)
  end
  
  def adopted_by_editor_notice(options)
    to = [Journal::Settings::EDITOR_EMAIL, options[:user].email].join(', ')
    reply_to = options[:user].email
    subject = "#{options[:submission].slug_display} has been adopted by #{options[:user].name}"
    from = Journal::Settings::APPLICATION_EMAIL
    @message =<<EndOfMessage

  The submission, #{options[:submission].slug_display}, has been adopted by #{options[:user].name}.

  The current status of the submission is now: #{options[:submission].state_display}.

  You can view the submission on-line at: #{Journal::Settings::SUBMISSIONS_URL}#{options[:submission].cached_slug}

  Sincerely,
  #{Journal::Settings::NAME} Managing Staff

===========================
This is an automated message sent by the #{Journal::Application::NAME} at #{Journal::Settings::EDITORIAL_SITE}
For questions, please contact #{Journal::Settings::SUPPORT_EMAIL}.

EndOfMessage
    mail(:to => to,
         :reply_to => reply_to,
         :subject => subject,
         :from => from)
  end
  
  def due_notice(options)
    to = Journal::Settings::EDITOR_EMAIL
    reply_to = Journal::Settings::APPLICATION_EMAIL
    subject = options[:subject]
    from = Journal::Settings::APPLICATION_EMAIL
    @message = "".html_safe
    @message << "<h3>#{subject}</h3>".html_safe
    @message << options[:body].html_safe
    mail(:to => to,
         :subject => subject,
         :from => from)
  end
end
