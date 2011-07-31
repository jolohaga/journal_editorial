require 'base64'
class EmailPreSubmission < ActiveRecord::Base
  has_one :pre_submission_entry, :as => :submission
  
  # Overcome non-UTF-8 encoding issues when writing to the database
  # by first encoding the body and subject of the email to base64
  #
  def body
    Base64::decode64(self[:body])
  end
  
  def body=(value)
    self[:body] = Base64::encode64(value)
  end
  
  def subject
    Base64::decode64(self[:subject])
  end
  
  def subject=(value)
    self[:subject] = Base64::encode64(value)
  end
  
  def display_description
    "Email <b>from</b> #{from} <b>on</b> #{submitted_at.to_s(:standard_display)}".html_safe
  end
end