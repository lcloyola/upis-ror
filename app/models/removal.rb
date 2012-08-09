class Removal < ActiveRecord::Base
  belongs_to :course
  belongs_to :student
  validates_uniqueness_of :course_id, :scope => [:student_id]

  def value
    return "(3.0)" if self.pass
    return "(5.0)"
  end
end

