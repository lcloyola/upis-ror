class Batch < ActiveRecord::Base
    validates_numericality_of :year, :only_integer => true, :message => "can only be whole number."
    validates_inclusion_of :year, :in => 1908..3000, :message => "can only be between 1908 and 3000."
    validates_uniqueness_of :year
    scope :current, :conditions => ['year <= ? AND year > ?', Schoolyear.current_schoolyear.first.start + 4, Schoolyear.current_schoolyear.first.start]
    
    has_many:students
    has_many:sections
end
