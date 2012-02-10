class Enrollees < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  attr_accessible :course_id, :student_id
  belongs_to :course
  belongs_to :student
end
