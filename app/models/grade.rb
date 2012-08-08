class Grade < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  validates_inclusion_of :value, :in => 0..100, :allow_nil => true, :message => "can only be between 0 and 100."
  validates_numericality_of :value, :only_integer => true, :allow_nil => true, :message => "can only be whole number."
  attr_accessible :course_id, :student_id, :value, :id, :quarter
  belongs_to :course
  belongs_to :student
  def blank
    return true unless !self.value.nil?
    return false
  end
  def writable?
    return false if (self.course.is_closed? and self.value.present?)
    return true
  end
end

