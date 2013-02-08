class Gwa < ActiveRecord::Base
  belongs_to :student
  belongs_to :schoolyear

  def self.search(schoolyear, batch, mode)
  	return Gwa.joins(:student).where('students.batch_id' => batch.id, 'schoolyear_id' => schoolyear.id, 'gwa_type' => mode)
  end

  def recompute
  	if self.gwa_type == GwaMode::Cumulative
  		courses = self.student.courses
  	elsif self.gwa_type == GwaMode::Schoolyear
  		courses = self.student.courses_year(self.schoolyear_id)
  	elsif self.gwa_type == GwaMode::Semester1
  		# TODO: confirm case for sems 3 & 4
  		courses = self.student.courses_sem(self.schoolyear_id, 1)
  	elsif self.gwa_type == GwaMode::Semester2
  		# TODO: confirm case for sems 3 & 4
  		courses = self.student.courses_sem(self.schoolyear_id, 2)
  	end
  	self.update_attribute(:raw, Gwa.gwa_raw_compute(courses, self.student))
  	self.update_attribute(:final, Gwa.gwa_final_compute(courses, self.student))
  end

  def self.gwa_final_compute(courses, student)
  	total = units = 0
  	courses.each do |c|
  		final = c.student_final(student.id)
  		final = student.course_removal_grade(c) if student.course_removed(c).present?
 			total = (final * c.subject.units) + total
 			units = c.subject.units + units 		
  	end
  	return (total / units).round(5) if units != 0
  	return ""
  end

  def self.gwa_raw_compute(courses, student)
  	total = units = 0
  	courses.each do |c|
  		raw = c.student_average(student.id)
 			total = (raw * c.subject.units) + total
 			units = c.subject.units + units 		
  	end
  	return (total / units).round(5) if units != 0
  	return ""
  end
end