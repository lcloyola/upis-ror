class Course < ActiveRecord::Base
  include GradesHelper

  validates_inclusion_of :sem, :in => 1..4, :message => "can only be from 1 or 2."
  validates_numericality_of :sem, :only_integer => true, :message => "can only be from 1 or 2."
  validates_uniqueness_of :section_id, :scope => [:schoolyear_id, :subject_id, :sem]
  validates_presence_of :schoolyear_id, :faculty_id, :subject_id, :sem, :section_id

  belongs_to :subject
  belongs_to :faculty
  belongs_to :schoolyear
  belongs_to :section
  has_many :grades, :foreign_key => :course_id, :dependent => :destroy
  has_many :students, :through => :grades, :uniq => true, :source => :student, :dependent => :destroy

  scope :first_sem, :conditions => ['sem = ?', 1]
  scope :with_deficiency, lambda { |quarter|
    includes(:grades).where('grades.quarter = ? and grades.value IS NULL', quarter)
  }

  def self.pending_requests
    return Course.where('schoolyear_id = ? AND is_locked = ?', Schoolyear.current.id, CourseStatus::Pending)
  end

  def my_students
    return Grade.where('course_id = ?', self.id).group_by(&:student)
  end

  # get course grades of students that belong to specific sem
  # get the average (not rounded)
  def student_sem_average(student_id, sem)
    query = 'student_id = ? AND course_id = ? AND VALUE IS NOT NULL '
    sem == 1 ? query << 'AND quarter <= 2' : query << 'AND quarter > 2'
    @grades = Grade.where(query, student_id, self.id)

    sum = @grades.sum('value').to_f
    return 0 if self.subject.is_pe or @grades.empty?
    return (sum / @grades.count)
  end
  # translate student sem averege to 11pt system
  def student_sem_final(student_id, sem)
    return 0 if self.subject.is_pe
    return elevenpt(self.student_sem_average(student_id, sem))
  end


  # get course grades of students (disregard null)
  # get the average (rounded)
  def student_average(student_id)
    @grades = Grade.where('student_id = ? AND course_id = ? AND VALUE IS NOT NULL', student_id, self.id)
    sum = @grades.sum('value').to_f
    return 0 if self.subject.is_pe or @grades.empty?
    return (sum / @grades.count).round
  end
  # translate student averege to 11pt system
  # refactor?
  def student_final(student_id)
    return 0 if self.subject.is_pe
    return elevenpt(self.student_average(student_id))
  end


  def student_decision(student)
    return "" if self.subject.is_pe
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
    elsif self.sem == 2
      return "2nd sem"
    elsif self.sem == 3
      return "1st & 3rd qtr"
    elsif self.sem == 4
      return "2nd & 4th qtr"
    end
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