class Subject < ActiveRecord::Base
  validates_inclusion_of :year, :in => 0..13, :message => "can only be from 0 and 13."
  validates_numericality_of :year, :only_integer => true, :message => "can only be whole number."
  validates_uniqueness_of :name, :scope => [:units, :year, :department_id]
  validates_presence_of :department_id, :units, :year, :name
  
  belongs_to :department
  has_many :courses
  
  def details
    "#{name} ( #{units} units )"
  end
end
