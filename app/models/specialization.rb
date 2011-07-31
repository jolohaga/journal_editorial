class Specialization < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates :name, :presence => true, :uniqueness => true
  
  CATEGORIES = %w{Languages/Environments Fields Statistical\ Concerns}
end