class WebPreSubmission < ActiveRecord::Base
  has_one :pre_submission_entry, :as => :submission
  
  def display_description
    "Web submission <b>from</b> <b>on</b> #{created_at.to_s(:standard_display)}".html_safe
  end
end