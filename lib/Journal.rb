module Journal
  class Application
    NAME = 'Journal Editorial Application'
  end
  
  # NAMESPACE
  # Custom class name for the journal.  Must be capitalized, since a class will created with it.
  # Keep it short.  Recommend using the journal's initials.
  # Used for namespaced class methods used in the form letters.
  # Example: Please reply to <%= JSS.editor_email %>
  #
  NAMESPACE = 'NS'
  
  class Settings
    # Publication settings
    NAME = "Journal's name goes here"
    CODEN = "Journal's Coden goes here"
    ISSN = "Journal's ISSN goes here"
    PUBLICATION_SITE = "Journal's publication url goes here"
    EDITORIAL_SITE = "Journal's editorial url goes here (this app's url)"
    OAI_IDENTIFIER = "Journal's OAI ID goes here"
    EDITOR_EMAIL = "editor@journal.domain"                # Where reply-to in form letters will be sent
    APPLICATION_EMAIL = "webapp-noreply@journal.domain"   # Application sends emails as this entity
    SUPPORT_EMAIL = "support@journal.domain"              # Who to contact for technical support
    
    # Start: LEAVE ALONE
    #
    SUBMISSIONS_URL = "#{EDITORIAL_SITE}/submissions/"
    FOLDERS_URL = "#{EDITORIAL_SITE}/folders/"
    
    # Short URL settings
    #
    # Examples:
    #   JSS-200
    #   JSS-200:FOLDER-10
    #   JSS-200:FOLDER-10:DOC-3
    #
    SUBMISSION_PREFIX = 'JSS'
    FOLDER_PREFIX = 'FOLDER'
    DOCUMENT_PREFIX = 'DOC'
    #
    # End: LEAVE ALONE
  end
  
  class Users
    # First account created by initialize rake task
    #
    ADMIN_NAME = 'Administrator'
    ADMIN_USERNAME = 'admin'
    ADMIN_EMAIL = 'admin@journal.domain'
    ADMIN_PASSWORD = 'changeme'
    DEFAULT_ASSOCIATE_PASSWORD = 'changeme'
  end
  
  class FormLetters
    FROM = [Settings::EDITOR_EMAIL]
    REPLY_TO = [Settings::EDITOR_EMAIL]
    SIGNATURE = <<-EndOfSignature
Best Regards,
Editor-in-chief's signature goes here
EndOfSignature
  end
  
  # Start: LEAVE ALONE
  #
  class Production
    DEADLINES = {
      :submitted            => ["-14",   "+7",  "-7"],
      :awaiting_review      => ["<<3",   "+7",  "-7"],
      :undergoing_revision  => ["<<12", ">>1", "<<1"],
      :final_screening      => ["<<12", ">>1", "<<1"],
      :reviewing            => ["<<2",   "+7",  "-7"],
      :pending              => ["<<2",   "+7",  "-7"],
      :publishing           => ["<<12", ">>1", "<<1"]
      
    }    
    class << self
      DEADLINES.keys.each do |state|
        instance_eval do
          define_method "#{state.to_s}_dates" do
            return {:due => eval("Date.today#{DEADLINES[state][0]}"), :max => eval("Date.today#{DEADLINES[state][1]}"), :min => eval("Date.today#{DEADLINES[state][2]}")}
          end
        end
      end
    end
  end
  
  # Create class methods namespaced to the journal's handle
  # for more direct access to the journal instance settings
  # within the form letters.
  #
  # These methods are namespaced to the journal instance and
  # not for use in the journal instance's agnostic codebase.
  #
  class << Object.const_set(NAMESPACE, Class.new)
    def editor_email
      Settings::EDITOR_EMAIL
    end
    
    def editorial_site
      Settings::EDITORIAL_SITE
    end
    
    def publication_site
      Settings::PUBLICATION_SITE
    end
    
    def submissions_url
      Settings::SUBMISSIONS_URL
    end
    
    def folders_url
      Settings::FOLDERS_URL
    end
  end
  #
  # End: LEAVE ALONE
end