class Course < ActiveRecord::Base
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

  def my_students
    return Grade.where('course_id = ?', self.id).group("student_id")
  end
  
  def student_average(student_id)
    @grades = Grade.where('student_id = ? AND course_id = ?', student_id, self.id).sum('value')
    if self.yearlong
      return @grades / 4.00
    else
      return @grades / 2.00    
    end
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
end
