class NotificationsController < ApplicationController
  before_filter :find_notifiable
  respond_to :html, :xml
  load_and_authorize_resource :class => 'FormLetter'
  
  def index
    @form_letters = FormLetter.where("form_letters.notifiable_type = '#{@notifiable.class.name}' AND form_letters.id IN (?)", Tag.where("tags.taggable_type = 'FormLetter' AND tags.name IN (?)", @notifiable.submission.states.collect {|state| state.state}).collect {|tag| tag.taggable_id})
  end

  def show
    @form_letter = FormLetter.find(params[:id])
    @to = "#{ERB.new(@form_letter.default_recipients).result(binding)}"
    @cc = "#{@form_letter.default_cc_recipients}"
    @bcc = "#{@form_letter.default_bcc_recipients}"
    @reply_to = "#{@form_letter.default_reply_to}"
    @from = "#{@form_letter.default_from}"
    @subject = "#{ERB.new(@form_letter.subject).result(binding)}"
    @message =<<-EndOfMessage
#{ERB.new(@form_letter.body).result(binding)}

#{@form_letter.signature}
EndOfMessage
    session[:notifiable_path] = send("#{@notifiable.class.name.downcase}_notifications_path",@notifiable)
  end
  
  def submit
    NotificationMailer.notify(:to => params[:to],
                              :cc => params[:cc],
                              :bcc => params[:bcc],
                              :reply_to => params[:reply_to],
                              :subject => params[:subject],
                              :from => params[:from],
                              :body => params[:body]).deliver
    flash[:notice] = 'Notification successfully sent.'
    notifiable_path,session[:notifiable_path] = session[:notifiable_path],nil
    send('redirect_to', notifiable_path)
  end
  
  def find_notifiable
    params.each do |name,value|  
      if name =~ /(.+)_id$/
        @notifiable = $1.classify.constantize.find(value)
        @submission = @notifiable.submission
        instance_variable_set("@#{$1}",@notifiable) unless @notifiable.class.name == 'Submission'
        break
      end
    end
  end
end