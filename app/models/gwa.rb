class Gwa < ActiveRecord::Base
  belongs_to :student
  belongs_to :schoolyear

  def self.search(schoolyear, batch, mode)
  	return Gwa.joins(:student).where('students.batch_id' => batch.id, 'schoolyear_id' => schoolyear.id, 'gwa_type' => mode)
  end

  # refactor? computation involves 1 controller and 3 models >.<
  def recompute
    # get involved courses
    if self.gwa_type == GwaMode::Cumulative
  		courses = self.student.courses
  	else
  		courses = self.student.courses_year(self.schoolyear_id)
  	end

    # compute raw and final gwa
    if self.gwa_type == GwaMode::Semester1
      self.raw = Gwa.gwa_raw(courses, self.student, 1)
      self.final = Gwa.gwa_final(courses, self.student, 1)
    elsif self.gwa_type == GwaMode::Semester2
      self.raw = Gwa.gwa_raw(courses, self.student, 2)
      self.final = Gwa.gwa_final(courses, self.student, 2)
    else
      self.raw = Gwa.gwa_raw(courses, self.student, 0)
      self.final = Gwa.gwa_final(courses, self.student, 0)
    end
    self.save
  end

  def self.gwa_final(courses, student, sem)
  	total = units = 0
  	courses.each do |c|
      if sem == 0
    		final = c.student_final(student.id)
    		final = student.course_removal_grade(c) if student.course_removed(c).present?
      else # semestral case
        final = c.student_sem_average(student.id, sem)
      end
 			total = (final * c.subject.units) + total
 			units = c.subject.units + units 		
  	end
  	return (total / units).round(5) if units != 0
  	return ""
  end

  def self.gwa_raw(courses, student, sem)
  	total = units = 0
  	courses.each do |c|
      if sem == 0
  		  raw = c.student_average(student.id)
      else  # semestral case
        raw = c.student_sem_average(student.id, sem)
      end
 			total = (raw * c.subject.units) + total
 			units = c.subject.units + units 		
  	end
  	return (total / units).round(5) if units != 0
  	return ""
  end
end