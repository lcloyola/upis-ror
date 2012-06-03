class Member < ActiveRecord::Base
  validates_uniqueness_of :section_id, :scope => [:student_id]
  validates :section_id, :student_id,  :presence => true
  attr_accessible :section_id, :student_id
  belongs_to :section
  belongs_to :student
end
