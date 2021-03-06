class Student < ActiveRecord::Base
  include GradesHelper

  belongs_to :batch
  has_many :grades, :foreign_key => :student_id, :dependent => :destroy
  has_many :courses, :through => :grades, :uniq => true, :source => :course, :dependent => :destroy
  has_many :members, :foreign_key => :student_id, :dependent => :destroy
  has_many :sections, :through => :members, :source => :section, :dependent => :destroy
  has_many :subjects, :through => :courses, :uniq => true, :source => :subject
  has_many :schoolyears, :through => :courses, :source => :schoolyear
  def fullname
    "#{last} #{given} #{middle}".upcase
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
    course = Course.find(course_id)
    self.course_grades(course_id).each do |g|
      if !course.subject.is_pe && !g.value.nil? && g.value < 50
        return true
      elsif course.subject.is_pe && g.value == 0
        return true
      end
    end
    return false
  end

  def course_grades(course_id)
    return Grade.where('course_id = ? and student_id = ?', course_id, self.id)
  end
  def courses_year(sy, ordinal = false)
    order = "units DESC, year DESC,sem ASC, name ASC"
    order = "ordinality DESC, " + order if ordinal
    return self.courses.joins(:subject).where('schoolyear_id = ?', sy).order(order).group("subject_id")
  end
  def course_removed(course)
    return Removal.where('student_id = ? and course_id = ?', self.id, course.id).first
  end
  def course_removal_grade(course)
    removal = self.course_removed(course)
    if removal.present?
      return 3.0 if removal.pass
      return 5.0
    end
    return nil
  end
  def section(schoolyear_id)
    return self.sections.where('schoolyear_id =?', schoolyear_id).first
  end
  def has_grades?
    return true if self.sections.present? || self.grades.present?
    return false
  end
  def units_overall
    return self.subjects.to_a.sum(&:units)
  end

  def has_deficiency?(sy, sem)
    grades = self.grades.joins(:course).where('courses.schoolyear_id = ? AND (value IS NULL OR value = 0)', sy.id)
    if sem == 1
      grades = grades.where('quarter <= 2')
    elsif sem == 2
      grades = grades.where('quarter > 2')
    end
    return grades.first
  end

  def has_failing?(sy, sem)
    grades = self.grades.joins(:course => :subject)
    grades = grades.where('courses.schoolyear_id = ? AND value IS NOT NULL AND value < 50', sy.id)
    grades = grades.where('subjects.is_pe = ?', false)
    if sem == 1
      grades = grades.where('quarter <= 2')
    elsif sem == 2
      grades = grades.where('quarter > 2')
    end
    return grades.first
  end
  def gwa_raw_schoolyear(sy)
    total = units = 0
    self.courses_year(sy.id).each do |c|
      total = (c.student_average(self.id) * c.subject.units) + total
      units = c.subject.units + units
    end
    return (total/units).round(5) if units != 0
  end

  def gwa_final_schoolyear(sy)
    total = units = 0
    self.courses_year(sy.id).each do |c|
      final = c.student_final(self.id)
      final = self.course_removal_grade(c) if self.course_removed(c).present?
    
      total = (final * c.subject.units) + total
      units = c.subject.units + units
    end
    return (total/units).round(5) if units != 0
    return ""
  end

  def gwa_final_overall
    total = units = 0
    self.courses.each do |c|
      final = c.student_final(self.id)
      final = self.course_removal_grade(c) if self.course_removed(c).present?
      total = ( final * c.subject.units) + total
      units = c.subject.units + units
    end
    return (total/units).round(5) if units != 0
    return ""
  end

  def courses_sy_range(sy_start, sy_end)
    sy_end = sy_start if sy_start > sy_end
    sql = "select
              student_id, course_id, schoolyear_id, start, subjects.units,
              name, IF(AVG(value) IS NULL, 0, AVG(value)) as raw
          from grades
          join courses on grades.course_id = courses.id
          join subjects on courses.subject_id = subjects.id
          join schoolyears on courses.schoolyear_id = schoolyears.id
          where start >= "+sy_start+" AND
               start <= "+sy_end+" AND
               student_id ="+self.id.to_s+"
          group by course_id;";
    return Student.connection.select_all(sql)
  end

  def final_gwa_range(sy_start, sy_end)
    courses = self.courses_sy_range(sy_start, sy_end)
    total = total_raw = units = 0
    a = Hash.new
    courses.each do |c|
      raw = c["raw"].round
      final = elevenpt(raw)

      removal = Removal.where('student_id = ? and course_id = ?', self.id, c["course_id"]).first
      final = removal.final if removal.present?

      total = (final * c["units"]) + total
      total_raw = (raw * c["units"]) + total_raw
   		units = c["units"] + units
    end
    a[:final] = (total / units).round(5) if units != 0
    a[:raw] = (total_raw / units).round(5) if units != 0
    return a
  end

  def sy_string(mode)
    x = "asc"
    x = "desc" if mode == "end"
    sy = self.schoolyears.group(:schoolyear_id).order("start #{x}").first
    unless sy.nil?
      return (sy.start - 1).to_s if mode == "end"
      return sy.start.to_s
    end
  end
end

