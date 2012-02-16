class Course < ActiveRecord::Base
  validates_inclusion_of :sem, :in => 1..2, :message => "can only be from 1 or 2."
  validates_numericality_of :sem, :only_integer => true, :message => "can only be from 1 or 2."
  validates_uniqueness_of :section_id, :scope => [:schoolyear_id, :subject_id, :sem]
  validates_presence_of :schoolyear_id, :faculty_id, :subject_id, :sem
  
  belongs_to :subject
  belongs_to :faculty
  belongs_to :schoolyear
  belongs_to :section
  has_many :enrollees, :foreign_key => :course_id, :dependent => :destroy
  has_many :students, :through => :enrollees, :source => :student, :dependent => :destroy
  accepts_nested_attributes_for :enrollees
  
  def semname
    if self.sem == 1
      return "1st sem"
    end
    return "2nd sem"
  end
end
