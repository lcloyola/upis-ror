class Student < ActiveRecord::Base
  belongs_to :batch
  has_many :enrollees, :foreign_key => :student_id, :dependent => :destroy
  has_many :courses, :through => :enrollees, :source => :course, :dependent => :destroy
  
  def fullname
    "#{last} #{given} #{middle}"
  end
end
