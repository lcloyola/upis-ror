class Course < ActiveRecord::Base
  include GradesHelper

  validates_inclusion_of :sem, :in => 1..2, :message => "can only be from 1 or 2."
  validates_numericality_of :sem, :only_integer => true, :message => "can only be from 1 or 2."
  validates_uniqueness_of :section_id, :scope => [:schoolyear_id, :subject_id, :sem]
  validates_presence_of :schoolyear_id, :faculty_id, :subject_id, :sem

  belongs_to :subject
  belongs_to :faculty
  belongs_to :schoolyear
  belongs_to :section
  has_many :grades, :foreign_key => :course_id, :dependent => :destroy
  has_many :students, :through => :grades, :source => :student, :dependent => :destroy

  scope :first_sem, :conditions => ['sem = ?', 1]
  scope :with_deficiency, lambda { |quarter|
    includes(:grades).where('grades.quarter = ? and grades.value IS NULL', quarter)
  }

  def my_students
    return Grade.where('course_id = ?', self.id).group_by(&:student)
  end
  def semname
    if self.sem == 1
      return "1st sem"
    end
    return "2nd sem"
  end
  def dq_students(quarter)
    return self.grades.find(:all, :conditions => ["value IS NULL AND quarter = ?", quarter])
  end

  def has_grade?
    self.grades.reject! { |item|
      return true  if item.value != nil
    }
    return false
  end
  def unenroll_students
    self.grades.delete_all if !self.has_grade?
  end
end

