require 'base64'
class Correspondence < ActiveRecord::Base
  has_many :attachments, :dependent => :destroy
  
  scope :hidden, where("hidden = 'T'")
  scope :unhidden, where("hidden = 'F'")
  scope :without_errors, where("error_status IS NULL")
  scope :with_errors, where("NOT error_status IS NULL")
  scope :with_attachments, includes(:attachments).where('correspondence.id = attachments.correspondence_id')
  
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
end