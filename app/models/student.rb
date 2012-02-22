class Student < ActiveRecord::Base
  belongs_to :batch
  has_many :enrollees, :foreign_key => :student_id, :dependent => :destroy
  has_many :courses, :through => :enrollees, :source => :course, :dependent => :destroy
  has_many :members, :foreign_key => :student_id, :dependent => :destroy
  has_many :sections, :through => :members, :source => :course, :dependent => :destroy
  
  def fullname
    "#{last} #{given} #{middle}"
  end
  
  def sn_fullname
    "#{student_no} - #{last} #{given} #{middle}"
  end
  
  def enrolled?(course_id = nil)
    unless Enrollee.where("course_id = ? AND student_id = ?", course_id, self.id).empty?
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
end
