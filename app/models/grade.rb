class Grade < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  validates_inclusion_of :value, :in => 0..100, :allow_nil => true, :message => "can only be between 0 and 100."
  validates_numericality_of :value, :only_integer => true, :allow_nil => true, :message => "can only be whole number."
  attr_accessible :course_id, :student_id, :value, :id, :quarter, :updated_by
  belongs_to :course
  belongs_to :student

  belongs_to :updator, foreign_key: "updated_by", class_name: "User"

  def blank
    return true unless !self.value.nil?
    return false
  end
  def writable?
    return false if (self.course.is_closed? and self.value.present?)
    return true
  end
  def self.deficiencies(quarter, schoolyear)
    return Grade.joins(:course).where('courses.schoolyear_id' => schoolyear, 'quarter' => quarter, 'value' => nil).group_by(&:course)
  end
end

