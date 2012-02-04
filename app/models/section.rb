class Section < ActiveRecord::Base
  validates_inclusion_of :year, :in => 1..5, :message => "can only be from 1 and 5."
  validates_numericality_of :year, :only_integer => true, :message => "can only be whole number."
  validates_uniqueness_of :name, :scope => [:schoolyear_id]
  validates_presence_of :schoolyear_id, :faculty_id, :batch_id, :year, :name
  
  belongs_to :schoolyear
  belongs_to :faculty
  belongs_to :batch
end
