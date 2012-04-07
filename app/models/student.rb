class Student < ActiveRecord::Base
  belongs_to :batch
  has_many :grades, :foreign_key => :student_id, :dependent => :destroy
  has_many :courses, :through => :grades, :source => :course, :dependent => :destroy
  has_many :members, :foreign_key => :student_id, :dependent => :destroy
  has_many :sections, :through => :members, :source => :section, :dependent => :destroy
  has_many :subjects, :through => :courses, :source => :subject
  has_many :schoolyears, :through => :courses, :source => :schoolyear
  def fullname
    "#{last} #{given} #{middle}"
  end
  
  def sn_fullname
    "#{student_no} - #{last} #{given} #{middle}"
  end
  
  def enrolled?(course_id = nil)
    unless Grade.where("course_id = ? AND student_id = ?", course_id, self.id).empty?
      return true
    end
    return false
  end
  def member?(section_id = nil)
    if Member.where("section_id = ? AND student_id = ?", section_id, self.id).empty?
      return false
    end
    return true
  end  
  def course_has_grade(course_id)
    @grades = Grade.where('course_id = ? and student_id = ?', course_id, self.id)
    @grades.each do |g|
      if !g.value.nil?; return true ; end
    end
    return false
  end
  def course_has_blank(course_id)
    self.course_grades(course_id).each do |g|
      if g.value.nil?; return true ; end
    end
    return false
  end
  def course_has_failing(course_id)
    self.course_grades(course_id).each do |g|
      if !g.value.nil? && g.value < 50; return true ; end
    end
    return false
  end
  def course_grades(course_id)
    return Grade.where('course_id = ? and student_id = ?', course_id, self.id)
  end
  def courses_year(sy)
    return self.courses.where('schoolyear_id = ?', sy).group("subject_id")
  end
  def course_removed(course)
    return Removal.where('student_id = ? and course_id = ?', self.id, course.id).first
  end
  def section(schoolyear_id)
    return self.sections.where('schoolyear_id =?', schoolyear_id).first
  end
end
