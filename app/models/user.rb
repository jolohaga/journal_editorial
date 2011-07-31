class User < ActiveRecord::Base
  include SentientUser
  include ActionView::Helpers::DateHelper
  
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :name, :email, :password, :active, :password_confirmation, :remember_me
  validates_presence_of :first_name, :last_name
  before_save :set_name
  has_and_belongs_to_many :roles
  has_many :assignments
  has_many :responsibilities, :through => :assignments, :source => :submission
  has_many :comments
  has_and_belongs_to_many :specializations
  has_many :commitments, :class_name => 'Observation', :foreign_key => 'committer_id'
  
  has_friendly_id :name, :use_slug => true
  
  scope :active, where("active = 'T'")
  scope :associates, includes(:roles).where(or_expand("roles.name",Role::ASSIGNABLE_ROLES))
  scope :editors, includes(:roles).where(or_expand('roles.name',Role::ASSOCIATE_EDITOR))
  scope :corresponding_authors, includes(:roles).where(or_expand('roles.name',Role::CORRESPONDING_AUTHOR))
  scope :reviewers, includes(:roles).where(or_expand('roles.name',Role::REVIEWER))
  scope :managing_editors, includes(:roles).where(or_expand("roles.name",Role::MANAGING_EDITORS))
  
  # User#role?
  #
  # Test intersection between args list and roles in the user's Role model.
  #
  # Examples: (assuming user is assigned roles 'Editor in Chief', 'Corresponding Author')
  # user.role? :administrator
  # => false
  # user.role? :administrator, :corresponding_author
  # => true
  #
  def role?(*args)
    query = 'LOWER(name) = ' + args.map {|r| "'" + r.to_s.underscore.gsub(/_/," ").downcase + "'"}.join(' OR LOWER(name) = ')
    return !self.roles.where(query).empty?
  end
    
  def manager?
    role? *Role::MANAGERS
  end
  
  def managing_editor?
    role? *Role::MANAGING_EDITORS
  end
  
  def exempt?
    role? *Role::EXEMPT
  end
  
  def assignable?
    role? *Role::ASSIGNABLE_ROLES
  end
  
  def minimum_readonly?
    role? *Role::MINIMUM_READONLY
  end
  
  def noaccess?
    role? *Role::NOACCESS
  end
    
  class_eval do
    Role::ROLES.each do |role|
      define_method (role.gsub(/ /,'_').downcase + '?').to_sym do
        self.role? role
      end
    end
  end
  
  def sign_in(options = {})
    sign_in_at = "#{options[:when]}_sign_in_at"
    sign_in_ip = "#{options[:when]}_sign_in_ip"
    if self.send("#{sign_in_at}").nil?
      "Never"
    else
      "#{time_ago_in_words(self.send(sign_in_at)).capitalize} ago.&nbsp;&nbsp;From #{self.send(sign_in_ip)}".html_safe
    end
  end
    
  private
  def set_name
    self.name = "#{self.first_name} #{self.last_name}"
  end
end