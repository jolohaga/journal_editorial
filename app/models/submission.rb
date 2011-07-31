class Submission < ActiveRecord::Base
  has_many :folders, :dependent => :destroy
  has_many :states, :as => :stateful_entity, :dependent => :destroy
  has_many :assignments, :dependent => :delete_all
  accepts_nested_attributes_for :assignments
  has_many :involved, :through => :assignments, :source => :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :observations, :as => :observable, :dependent => :destroy
  has_many :observation_records, :class_name => 'Observation'
  
  has_friendly_id :assignment_id, :use_slug => true
  
  validates_presence_of :title
  validates :keywords, :length => {:maximum => 255}
  
  before_save :assign_number, :if => :assignment_number_blank?
  after_save :update_folder_assignments, :if => :assignment_number_changed?
  
  PAPER_TYPES = %w{Article Book\ Review Code\ Snippet Software\ Review}
  
  PUBLISHING_STATES = [
      ['Filter',['(off)']],
      ['Prescreening Stages',
        [['Active Under Prescreening', :active_under_prescreening],
         ['Submitted'.html_safe, :submitted],
         ['&nbsp;&nbsp;Prescreening'.html_safe, :prescreening]]],
      ['Review Stages',
        [['Active Under Review', :active_under_review],
         ['Awaiting Review', :awaiting_review],
         ['Orphaned', :orphaned],
         ['Reviewing', :reviewing],
           ['&nbsp;&nbsp;Pending Rejection'.html_safe, :pending_rejection],
           ['&nbsp;&nbsp;Pending Acceptance With Minor Modifications'.html_safe, :pending_acceptance_with_minor_modifications],
            ['&nbsp;&nbsp;Pending Revising'.html_safe, :pending_revising],
            ['&nbsp;&nbsp;Pending Acceptance'.html_safe, :pending_acceptance]]],
      ['Final Screening Stages',
        [['Active Under Final Screening', :active_under_final_screening],
         ['Final Screening', :final_screening],
           ['&nbsp;&nbsp;Publishing'.html_safe, :publishing]]],
      ['Interim Stages',
        [['Undergoing Revision', :undergoing_revision]]],
      ['Terminal Stages',
        [['Published', :published],
         ['Rejected', :rejected],
         ['Withdrawn', :withdrawn],
         ['Removed', :removed]]]]

  scope :created_at_desc, order('submissions.created_at DESC')
  scope :recorded_before, lambda {|date| where(["states.recorded_at <= ?", date])}
  scope :recorded_between, lambda {|min_date,max_date| where(["states.recorded_at BETWEEN ? AND ?", min_date, max_date])}
  scope :currently, lambda {|states_array|
    includes(:states).where("submissions.id IN (
      SELECT s1.stateful_entity_id
        FROM states s1, states s2
        WHERE s1.stateful_entity_id = s2.stateful_entity_id
        AND (#{or_expand('s1.state', states_array)})
        GROUP BY s2.stateful_entity_id, s1.stateful_entity_id, s1.created_at
        HAVING s1.created_at = MAX(s2.created_at))")
  }
  scope :currently_not, lambda {|states_array|
    includes(:states).where("submissions.id IN (
      SELECT s1.stateful_entity_id
        FROM states s1, states s2
        WHERE s1.stateful_entity_id = s2.stateful_entity_id
        AND (#{not_and_expand('s1.state', states_array)})
        GROUP BY s2.stateful_entity_id, s1.stateful_entity_id, s1.created_at
        HAVING s1.created_at = MAX(s2.created_at))")
  }
  
  # Pending submission
  # Submitted
  #   Rejected under submission
  # 		Removed †
  # 	Prescreening
  # 		Rejected under prescreening
  # 			Removed †
  # 		Revising under prescreening
  # 			Resubmitted (back to Prescreening)
  # 		Awaiting review
  # 			Reviewing
  # 				Re-queued (back to Awaiting review)
  # 				Pending acceptance
  # 					Final screening
  # 						Revising under final screening
  # 							Resubmitted (back to Final screening)
  # 						Publishing
  # 							Published †
  # 				Pending rejection
  # 					Rejected under review
  # 						Removed †
  # 				Pending acceptance with minor modifications
  # 					Revising with minor modifications
  # 						Resubmitted (back to Reviewing)
  # 				Pending revising
  # 					Revising under review
  # 						Resubmitted (back to Reviewing)
  # 			Orphaned
  # 				Re-queued (back to Awaiting review)
  # 				Removed †
  state_machine :initial => :pending_submission do
    event :submit do
      transition :pending_submission => :submitted
    end
    event :accept do
      transition :submitted => :prescreening, :pending_acceptance => :final_screening, :final_screening => :publishing, :prescreening => :awaiting_review
    end
    event :reject do
      transition :submitted => :rejected_under_submission, :prescreening => :rejected_under_prescreening, :pending_rejection => :rejected_under_review
    end
    event :withdraw do
      transition :prescreening => :withdrawn_under_prescreening, :reviewing => :withdrawn_under_review
    end
    event :recommend_rejecting do
      transition :reviewing => :pending_rejection
    end
    event :recommend_revising do
      transition :reviewing => :pending_revising
    end
    event :recommend_accepting do
      transition :reviewing => :pending_acceptance
    end
    event :recommend_accepting_with_minor_modifications do
      transition :reviewing => :pending_acceptance_with_minor_modifications
    end
    event :resubmit do
      transition :revising_under_prescreening => :prescreening
      transition :revising_under_review => :reviewing
      transition :revising_under_final_screening => :final_screening
      transition :revising_with_minor_modifications => :reviewing
    end
    event :adopt do
      transition :awaiting_review => :reviewing
    end
    event :assign do
      transition :awaiting_review => :reviewing
    end
    event :requeue do
      transition [:reviewing,:orphaned] => :awaiting_review
    end
    event :orphan do
      transition :awaiting_review => :orphaned
    end
    event :revise do
      transition :pending_revising => :revising_under_review, :final_screening => :revising_under_final_screening, :prescreening => :revising_under_prescreening
    end
    event :accept_with_minor_modifications do
      transition :pending_acceptance_with_minor_modifications => :revising_with_minor_modifications
    end
    event :publish do
      transition :publishing => :published
    end
    event :remove do
      transition [:orphaned, :rejected_under_submission, :rejected_under_prescreening, :rejected_under_review, :withdrawn_under_prescreening, :withdrawn_under_review] => :removed
    end
    state :pending_submission, :value => nil
    state :submitted do
      def stage_folders
        Folder::STAGE_1
      end
      def current_default_folder_name
        Folder::SUBMISSION
      end
    end
    state :rejected_under_submission do
      def stage_folders
        Folder::STAGE_1
      end
      def current_default_folder_name
        Folder::SUBMISSION
      end
    end
    state :prescreening do
      def stage_folders
        Folder::STAGE_2
      end
      def current_default_folder_name
        Folder::SUBMISSION
      end
    end
    state :rejected_under_prescreening do
      def stage_folders
        Folder::STAGE_2
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_PRESCREENING
      end
    end
    state :withdrawn_under_prescreening do
      def stage_folders
        Folder::STAGE_2
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_PRESCREENING
      end
    end
    state :revising_under_prescreening do
      def stage_folders
        Folder::STAGE_3
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_PRESCREENING
      end
    end
    state :awaiting_review do
      def stage_folders
        Folder::STAGE_3
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_PRESCREENING
      end
    end
    state :orphaned do
      def stage_folders
        Folder::STAGE_3
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_PRESCREENING
      end
    end
    state :reviewing do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :pending_revising do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :pending_acceptance_with_minor_modifications do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :pending_rejection do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :pending_acceptance do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :rejected_under_review do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :withdrawn_under_review do
      def stage_folders
        Folder::STAGE_4
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :revising_under_review do
      def stage_folders
        Folder::STAGE_5
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :revising_with_minor_modifications do
      def stage_folders
        Folder::STAGE_5
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :final_screening do
      def stage_folders
        Folder::STAGE_6
      end
      def current_default_folder_name
        Folder::REVIEW
      end
    end
    state :revising_under_final_screening do
      def stage_folders
        Folder::STAGE_7
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_FINAL_SCREENING
      end
    end
    state :publishing do
      def stage_folders
        Folder::STAGE_8
      end
      def current_default_folder_name
        Folder::REVIEW_UNDER_FINAL_SCREENING
      end
    end
    state :removed, :published do
      def stage_folders
        Folder::STAGE_9
      end
      def current_default_folder_name
        Folder::SUBMISSION_UNDER_PUBLICATION
      end
    end
  end
  
  def terminal?
    self.class.state_machine(:state).states[self.state.symbolize].final?
  end
  
  class << self    
    Submission.state_machine.states.keys.each do |key|
      instance_eval do
        define_method key do
          self.currently([key.to_s])
        end
      end
    end
    
    def states
      self.state_machine.states.keys
    end
    
    def final
      Submission.state_machine.states.select {|state| state.final?}.map{|state| state.name}
    end
    
    def not_final
      states - final
    end
    
    def non_terminal_states
      states - (final + [:rejected_under_submission,:rejected_under_prescreening,:rejected_under_review,:withdrawn_under_prescreening,:withdrawn_under_review])
    end
  end
  
  scope :rejected, currently(['rejected_under_submission','rejected_under_prescreening','rejected_under_review'])
  scope :withdrawn, currently(['withdrawn_under_prescreening','withdrawn_under_review'])
  scope :undergoing_revision, currently(['revising_under_prescreening','revising_with_minor_modifications','revising_under_review','revising_under_final_screening'])
  scope :terminal, currently(['published','removed'])
  scope :pending_removal, currently(['rejected_under_submission', 'rejected_under_prescreening', 'orphaned', 'rejected_under_review', 'withdrawn_under_prescreening', 'withdrawn_under_review'])
  scope :pending, currently(['pending_revising', 'pending_acceptance_with_minor_modifications', 'pending_rejection', 'pending_acceptance'])
  scope :active_under_prescreening, currently(['submitted', 'prescreening', 'revising_under_prescreening', 'awaiting_review'])
  scope :active_under_review, currently(['reviewing', 'pending_acceptance', 'pending_rejection', 'pending_acceptance_with_minor_modifications', 'pending_revising', 'revising_with_minor_modifications', 'revising_under_review'])
  scope :active_under_final_screening, currently(['final_screening', 'revising_under_final_screening', 'publishing'])
  scope :non_terminal, currently_not(['published','rejected_under_submission','rejected_under_prescreening','rejected_under_review','removed','withdrawn_under_prescreening','withdrawn_under_review'])
  scope :unpublishable, currently(['rejected_under_submission','rejected_under_prescreening','rejected_under_review','removed','withdrawn_under_prescreening','withdrawn_under_review'])
  scope :reviewed_and_under_publication, currently(['final_screening','revising_under_prescreening','publishing','published'])
  scope :reviewed_and_under_removal, currently(['rejected_under_review','withdrawn_under_review','removed'])
  
  def current_state
    states.current_state.first
  end
  
  def prior_state_record
    states.prior_state.first
  end
  
  def state_for(state_record)
    state_record.nil? ? nil : state_record.state
  end
  
  def state
    state_for(current_state)
  end
  
  def state=(next_state)
    new_state = State.new(:state => next_state)
    states << new_state
  end
  
  def prior_state
    state_for(prior_state_record)
  end
  
  def revert_state!
    current_state.destroy
  end
  
  def state_ranges
    ranges = {}
    s = states.created_at_desc
    if s.length == 1
      ranges[s[0].state.titleize] = [s[0].recorded_at.to_s(:short_display), -1/0.0, 1/0.0]
      return ranges
    else
      ranges[s[0].state.titleize] = [s[0].recorded_at.to_s(:short_display), s[1].recorded_at.to_s(:short_display), 1/0.0]
    end
    1.upto(s.length-2) do |i|
      ranges[s[i].state.titleize] = [s[i].recorded_at.to_s(:short_display), s[i+1].recorded_at.to_s(:short_display), s[i-1].recorded_at.to_s(:short_display)]
    end
    ranges[s[s.length-1].state.titleize] = [s[s.length-1].recorded_at.to_s(:short_display), -1/0.0, s[-2].recorded_at.to_s(:short_display)]
    return ranges
  end
  
  def next_state_recordable_date_range
    (current_state.recorded_at..1/0.0)
  end
  
  def recorded_at_date_for_state(state)
    begin
      states.select{|s| s.state == "#{state}"}[0].recorded_at.to_s
    rescue
      ''
    end
  end
  
  def next_folder_assignment
    folders.maximum(:assignment_number).to_i + 1
  end
  
  def next_assignment_number
    folders.send(current_default_folder_name.symbolize).count+1
  end
  
  def assignment_id
    a = AssignmentNumber.first
    assignment_number.blank? ? "#{Journal::Settings::SUBMISSION_PREFIX} #{a.next_assignment_number}" : "#{Journal::Settings::SUBMISSION_PREFIX} #{assignment_number}"
  end
  
  def assignment_id=(assign_id)
    assignment_number = "#{assign_id.match(/\d+$/)[0]}"
  end
  
  def submission
    self
  end
  
  def slug_display
    cached_slug.upcase
  end
  
  def submission_id
    slug_display
  end
  
  def assignment_display
    slug_display + ': ' + title
  end
  
  def state_display
    ("#{state.titleize}, #{current_state.recorded_at.to_s(:short_display)}").html_safe
  end
  
  def assignment_number_blank?
    self.assignment_number.blank?
  end
  
  def assign_number
    if self.valid?
      number_cache = AssignmentNumber.first
      self.assignment_number = number_cache.next_assignment_number
      number_cache.increment!(:next_assignment_number)
    end
  end
  
  def update_folder_assignments
    folders.each do |folder|
      folder.update_attribute(:cached_slug, folder.assignment_id)
    end
  end
  
  # Involved methods
  #
  def editors
    involved.where("assignments.role = '#{Role::ASSOCIATE_EDITOR}'")
  end
  
  def corresponding_authors
    involved.where("assignments.role = '#{Role::CORRESPONDING_AUTHOR}'")
  end
  
  def reviewers
    involved.where("assignments.role = '#{Role::REVIEWER}'")
  end
  
  def authors_emails
    corresponding_authors.collect{|a| a.email}.join(', ')
  end
  
  # Folder methods
  #  
  def visited_folders
    folders.collect {|f| f.activity}
  end
  
  def available_folders
    (folders_for_visited_states + stage_folders).uniq.sort {|f1,f2| Folder::FOLDER_HIERARCHY[f1] <=> Folder::FOLDER_HIERARCHY[f2]}
  end
  
  def default_folder
    case [state,prior_state]
    # Submission
    when ['submitted',nil],
         ['rejected_under_submission','submitted'],
         ['prescreening','submitted']
      Folder::SUBMISSION
    # Review under prescreening
    when ['rejected_under_prescreening','prescreening'],
         ['revising_under_prescreening','prescreening'],
         ['awaiting_review','prescreening'],
         ['orphaned','awaiting_review'],
         ['withdrawn_under_prescreening','prescreening']
      Folder::REVIEW_UNDER_PRESCREENING
    # Resubmission under prescreening
    when ['prescreening', 'revising_under_prescreening']
      Folder::RESUBMISSION_UNDER_PRESCREENING
    # Review
    when ['reviewing', 'awaiting_review'],
         ['pending_rejection','reviewing'],
         ['rejected_under_review','pending_rejection'],
         ['pending_revising','reviewing'],
         ['revising_under_review','pending_revising'],
         ['pending_acceptance_with_minor_modifications','reviewing'],
         ['revising_with_minor_modifications','pending_acceptance_with_minor_modifications'],
         ['pending_acceptance','reviewing'],
         ['final_screening','pending_acceptance'],
         ['withdrawn_under_review','reviewing']
      Folder::REVIEW
    # Resubmission under review
    when ['reviewing','revising_under_review']
      Folder::RESUBMISSION_UNDER_REVIEW
    # Resubmission with minor modifications
    when ['reviewing','revising_with_minor_modifications']
      Folder::RESUBMISSION_WITH_MINOR_MODIFICATIONS
    # Review under final screening
    when ['revising_under_final_screening','final_screening'],['publishing','final_screening']
      Folder::REVIEW_UNDER_FINAL_SCREENING
    # Resubmission under final screening
    when ['final_screening','revising_under_final_screening']
      Folder::RESUBMISSION_UNDER_FINAL_SCREENING
    # Published
    when ['published','publishing']
      Folder::SUBMISSION_UNDER_PUBLICATION
    else
      ''
    end
  end
  
  def folders_for_visited_states
    states.collect do |s|
      case s.state
      # Unequivocal cases
      when 'submitted',
           'rejected_under_submission'
        [Folder::SUBMISSION]
      when 'rejected_under_prescreening',
           'withdrawn_under_prescreening',
           'awaiting_review'
        [Folder::REVIEW_UNDER_PRESCREENING]
      when 'pending_rejection',
           'rejected_under_review',
           'withdrawn_under_review',
           'pending_acceptance'
        [Folder::REVIEW]
      when 'publishing'
        [Folder::REVIEW_UNDER_FINAL_SCREENING]
      # Special cases
      when 'prescreening'
        [Folder::SUBMISSION]
      when 'revising_under_prescreening'
        [Folder::REVIEW_UNDER_PRESCREENING, Folder::RESUBMISSION_UNDER_PRESCREENING]
      when 'reviewing'
        [Folder::REVIEW_UNDER_PRESCREENING]
      when 'pending_revising','pending_acceptance_with_minor_modifications'
        [Folder::REVIEW]
      when 'revising_under_review'
        [Folder::REVIEW, Folder::RESUBMISSION_UNDER_REVIEW]
      when 'revising_with_minor_modifications'
        [Folder::REVIEW, Folder::RESUBMISSION_WITH_MINOR_MODIFICATIONS]
      when 'orphaned'
        [Folder::REVIEW_UNDER_PRESCREENING]
      when 'final_screening'
        [Folder::REVIEW]
      when 'revising_under_final_screening'
        [Folder::REVIEW_UNDER_FINAL_SCREENING, Folder::RESUBMISSION_UNDER_FINAL_SCREENING]
      else
        []
      end
    end.flatten.uniq
  end
end