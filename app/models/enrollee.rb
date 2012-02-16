class Enrollee < ActiveRecord::Base
  validates :course_id, :student_id,  :presence => true
  attr_accessible :course_id, :student_id, :quartera, :quarterb, :id
  belongs_to :course
  belongs_to :student
end
