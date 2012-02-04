class Faculty < ActiveRecord::Base
  belongs_to :department
  has_many :sections
  has_many :courses
  
  def fullname
    "#{last} #{given} #{middle}"
  end
end
