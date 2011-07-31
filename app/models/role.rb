class Role < ActiveRecord::Base
  include Comparable
  has_and_belongs_to_many :users
  validates_uniqueness_of :name
  
  ROLE_HIERARCHY = {'Unprivileged' => 0,
                    'Visitor' => 1,
                    'Corresponding Author' => 2,
                    'Reviewer' => 3,
                    'Associate Editor' => 4,
                    'Assistant' => 5,
                    'Editor in Chief' => 5,
                    'Assistant Editor' => 5,
                    'Technical Editor' => 5,
                    'Administrator' => 6}
  ROLES = ROLE_HIERARCHY.keys
  
  ROLES.each do |role|
    const_set(role.upcase.gsub(/ /,'_'), role)
  end
  
  MANAGERS = [ASSISTANT_EDITOR, ASSISTANT, ADMINISTRATOR]
  MANAGING_EDITORS = [EDITOR_IN_CHIEF, ASSISTANT_EDITOR, TECHNICAL_EDITOR]
  EXEMPT = [ASSOCIATE_EDITOR, CORRESPONDING_AUTHOR, REVIEWER] # Exempt from managerial duties
  ASSIGNABLE_ROLES = EXEMPT
  MINIMUM_READONLY = [VISITOR]
  NOACCESS = [UNPRIVILEGED]
  
  def <=>(other)
    ROLE_HIERARCHY[self.name] <=> ROLE_HIERARCHY[other.name]
  end
  
  scope :assignable, where(["name = ? OR name = ? OR name = ?", *ASSIGNABLE_ROLES])
end