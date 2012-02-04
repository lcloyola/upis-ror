class Student < ActiveRecord::Base
  belongs_to :batch
  
  def fullname
    "#{last} #{given} #{middle}"
  end
end
