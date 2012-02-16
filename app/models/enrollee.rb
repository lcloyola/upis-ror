class Enrollee < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  validates_numericality_of :quartera, :quarterb, :only_integer => true, :message => "can only be whole number."
  validates_inclusion_of :quartera, :quarterb, :in => 0..100, :message => "can only be between 0 and 100."
  attr_accessible :course_id, :student_id, :quartera, :quarterb, :id
  belongs_to :course
  belongs_to :student
end
