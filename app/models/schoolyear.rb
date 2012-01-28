class Schoolyear < ActiveRecord::Base
  validates_numericality_of :start, :only_integer => true, :message => "can only be whole number."
  validates_inclusion_of :start, :in => 1908..3000, :message => "can only be between 1908 and 3000."
  validates_uniqueness_of :start
end
