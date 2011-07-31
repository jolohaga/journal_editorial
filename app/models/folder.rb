class Folder < ActiveRecord::Base
  include Comparable
  belongs_to :submission
  has_many :documents, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  accepts_nested_attributes_for :comments
  has_many :observations, :as => :observable, :dependent => :destroy
  
  has_friendly_id :assignment_id, :use_slug => true
  
  FOLDERS = ['Submission',
             'Review under prescreening',
             'Resubmission under prescreening',
             'Review',
             'Resubmission under review',
             'Resubmission with minor modifications',
             'Review under final screening',
             'Resubmission under final screening',
             'Submission under publication']
             
  FOLDERS.each do |folder|
    #
    # Define array constants
    self.const_set(folder.gsub(/ /, '_').upcase.to_sym, folder)
    #
    # Define scope associations
    scope folder.symbolize, where("activity = '#{folder}'")
  end

  STAGE_1 = [SUBMISSION]
  STAGE_2 = STAGE_1 + [REVIEW_UNDER_PRESCREENING]
  STAGE_3 = STAGE_2 + [RESUBMISSION_UNDER_PRESCREENING]
  STAGE_4 = STAGE_3 + [REVIEW]
  STAGE_5 = STAGE_4 + [RESUBMISSION_UNDER_REVIEW, RESUBMISSION_WITH_MINOR_MODIFICATIONS]
  STAGE_6 = STAGE_5 + [REVIEW_UNDER_FINAL_SCREENING]
  STAGE_7 = STAGE_6 + [RESUBMISSION_UNDER_FINAL_SCREENING]
  STAGE_8 = STAGE_7 + [SUBMISSION_UNDER_PUBLICATION]
  STAGE_9 = STAGE_8
  
  FOLDER_HIERARCHY = Hash[*FOLDERS.zip(1..FOLDERS.length).flatten]
    
  def <=>(other)
    FOLDER_HIERARCHY[self.activity] <=> FOLDER_HIERARCHY[other.activity]
  end
  
  def assignment_id
    submission_slug = ''
    unless self.submission.nil?
      submission_slug = self.submission.cached_slug
    end
    "#{submission_slug}:folder-#{assignment_number}"
  end
  
  def assignment_id=(assign_id)
    assignment_number = "#{assign_id.match(/\d+$/)[0]}"
  end
  
  def normalize_friendly_id(text)
    text
  end
  
  def slug_display
    cached_slug
  end
  
  def activity_attempt_display
    (activity.titleize + (((' ' + attempt.ordinalize) unless attempt < 2) || '')).html_safe
  end
  
  def next_document_assignment
    documents.maximum(:assignment_number).to_i + 1
  end
end