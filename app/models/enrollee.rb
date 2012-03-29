class Enrollee < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  validates_inclusion_of :quartera, :quarterb, :in => 0..100, :allow_nil => true, :message => "can only be between 0 and 100."
  validates_numericality_of :quartera, :quarterb, :only_integer => true, :allow_nil => true, :message => "can only be whole number."
  attr_accessible :course_id, :student_id, :quartera, :quarterb, :id
  belongs_to :course
  belongs_to :student
  
  def blank?
    return false unless self.quartera.nil? || self.quarterb.nil?
    return true
  end
  def both_blank?
    return false unless self.quartera.nil? && self.quarterb.nil?
    return true
  end
end
