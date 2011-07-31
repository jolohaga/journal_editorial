class State < ActiveRecord::Base
  include Comparable
  
  belongs_to :stateful_entity, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :observations, :as => :observable, :dependent => :destroy
  
  has_friendly_id :assignment_id, :use_slug => true
  
  scope :recorded_at_desc, order('states.recorded_at DESC')
  scope :recorded_at_asc, order('states.recorded_at ASC')
  
  scope :created_at_desc, order('states.created_at DESC')
  scope :created_at_asc, order('states.created_at ASC')
  
  scope :current_state, created_at_desc.limit(1)
  scope :prior_state, current_state.offset(1)
  
  scope :currently, lambda {|state| select('s1.*').from('states s1, states s2').where("s1.stateful_entity_id = s2.stateful_entity_id and s1.state = ?", state).group('s2.stateful_entity_id, s1.id, s1.created_at, s1.state, s1.stateful_entity_id, s1.recorded_at, s1.stateful_entity_type, s1.updated_at').having('s1.created_at = max(s2.created_at)')}
    
  def <=>(other)
    self.created_at <=> other.created_at
  end
  
  def recordable_date_range
    stateful_entity.state_ranges[state.titleize][1,2].map {|r|
      r.respond_to?(:to_date) ? r.to_date : r
    }.inject{|lower,upper|
      (lower..upper)
    }
  end
  
  def assignment_id
    stateful_entity_slug = ''
    unless self.stateful_entity.nil?
      stateful_entity_slug = "#{self.stateful_entity.cached_slug}"
    end
    self.state.nil? ? [stateful_entity_slug, 'submitted'].join(':') : [stateful_entity_slug, self.state.gsub(/_/,'-')].join(':')
  end
  
  def submission
    stateful_entity.submission
  end
  
  def normalize_friendly_id(text)
    text
  end
end