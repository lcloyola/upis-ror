class Department < ActiveRecord::Base
  validates_uniqueness_of :name
  
  has_many :subjects
  has_many :faculties
end
