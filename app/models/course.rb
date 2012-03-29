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
  
  scope :first_sem, :conditions => ['sem = ?', 1]

  def semname
    if self.sem == 1
      return "1st sem"
    end
    return "2nd sem"
  end
  
  def partner_sem
    if self.sem == 1; p = 2
    else; p = 1; end
    
    return Course.where('subject_id = ? AND schoolyear_id = ? AND section_id = ? AND sem = ?', self.subject_id, self.schoolyear_id, self.section_id, p).first
  end
  
  def yearmode_students
    if !self.partner_sem.nil?
      return Enrollee.where('course_id = ? OR course_id = ?', self.id, self.partner_sem.id).group("student_id")
    else
      return self.enrollees
    end
  end

  def find_sem2_enrollee(student_id = nil)
    return Enrollee.where('student_id = ? AND course_id = ?', student_id, self.id).first
  end
end
