class Course < ActiveRecord::Base
  include GradesHelper

  validates_inclusion_of :sem, :in => 1..2, :message => "can only be from 1 or 2."
  validates_numericality_of :sem, :only_integer => true, :message => "can only be from 1 or 2."
  validates_uniqueness_of :section_id, :scope => [:schoolyear_id, :subject_id, :sem]
  validates_presence_of :schoolyear_id, :faculty_id, :subject_id, :sem, :section_id

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

  def self.pending_requests
    return Course.where('schoolyear_id = ? AND is_locked = ?', Schoolyear.current_schoolyear.first.id, CourseStatus::Pending)
  end

  def my_students
    return Grade.where('course_id = ?', self.id).group_by(&:student)
  end
  def student_average(student_id)
    @grades = Grade.where('student_id = ? AND course_id = ? AND VALUE IS NOT NULL', student_id, self.id)
    sum = @grades.sum('value')
    return 0 if self.subject.is_pe?
    return 0 if @grades.empty?
    return (sum / @grades.count).round
    #if self.yearlong
    #  return (@grades / 4.00).round
    #else
    #  return (@grades / 2.00).round
    #end
  end
  def student_final(student_id)
    return 0 if self.subject.is_pe?
    return elevenpt(self.student_average(student_id))
  end
  def student_decision(student)
    return "" if self.subject.is_pe?
    final = self.student_final(student.id)
    removal = Student.find(student.id).course_removed(self)
    final = removal if removal.present?

    grade = final
    decision = case grade
      when 1.0..3.0 then "Pasado"
      when 4.0 then " "
      when 0 then " "
      when "(3.0)" then "Pasado"
      when "(5.0)" then "Di Pasado"
      else "Di Pasado"
    end
    return decision
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

  def is_closed?
    return true if self.is_locked != CourseStatus::Open
  end

end

