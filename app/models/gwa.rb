class Gwa < ActiveRecord::Base
  belongs_to :student
  belongs_to :schoolyear

  def self.search(schoolyear, batch, mode)
  	gwas = Gwa.joins(:student)
    gwas = gwas.where('students.batch_id' => batch.id, 'schoolyear_id' => schoolyear.id, 'gwa_type' => mode)
    gwas = gwas.each{|s| s[:deficiency] = s.student.has_deficiency?(schoolyear, mode - 1)}
    return gwas.each{|s| s[:failing] = s.student.has_failing?(schoolyear, 0)}
  end

  # refactor? computation involves 1 controller and 3 models >.<
  def recompute
    # get involved courses
    if self.gwa_type == GwaMode::Cumulative
  		courses = self.student.courses
  	else
  		courses = self.student.courses_year(self.schoolyear_id)
  	end

    sem = self.gwa_type - 1 # 1st sem and 2nd sem cases
    sem = 0 if self.gwa_type == GwaMode::Schoolyear || self.gwa_type == GwaMode::Cumulative

    self.raw = Gwa.gwa_raw(courses, self.student, sem)
    self.final = Gwa.gwa_final(courses, self.student, sem)

    self.save
  end

  # this is not valid for semestral case.
  def self.gwa_final(courses, student, sem)
  	total = units = 0
  	courses.each do |c|
      if sem == 0
    		final = c.student_final(student.id)
    		final = student.course_removal_grade(c) if student.course_removed(c).present?
      else # semestral case
        final = c.student_sem_final(student.id, sem)
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
 			unless raw == 0
        total = (raw * c.subject.units) + total
        units = c.subject.units + units
      end
  	end
  	return (total / units).round(5) if units != 0
  	return ""
  end
end