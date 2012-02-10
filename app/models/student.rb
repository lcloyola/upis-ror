class Student < ActiveRecord::Base
  belongs_to :batch
  belongs_to :enrollee
  
  def fullname
    "#{last} #{given} #{middle}"
  end
end
