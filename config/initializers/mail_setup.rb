# Turn on email for all environments
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "journal.smtp.server",
   :port => 25,
   :domain => "localhost",
   :authentication => :cram_md5,
   :user_name => "sender_username",
   :password => "sender_password"
}
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"