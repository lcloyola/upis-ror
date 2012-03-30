class Student < ActiveRecord::Base
  belongs_to :batch
  has_many :enrollees, :foreign_key => :student_id, :dependent => :destroy
  has_many :courses, :through => :enrollees, :source => :course, :dependent => :destroy
  has_many :members, :foreign_key => :student_id, :dependent => :destroy
  has_many :sections, :through => :members, :source => :section, :dependent => :destroy
  
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
  def enrollment(course_id = nil)
    return Enrollee.where("course_id = ? AND student_id = ?", course_id, self.id).first
  end
  
  def has_grade(course_id)
    @grades = Grade.where('course_id = ? and student_id = ?', course_id, self.id)
    @grades.each do |g|
      if !g.value.nil?; return false ; end
    end
    return true
  end
  def my_grades(course_id)
    return Grade.where('course_id = ? and student_id = ?', course_id, self.id)
  end
end
