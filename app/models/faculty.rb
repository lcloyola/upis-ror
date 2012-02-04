class Faculty < ActiveRecord::Base
  belongs_to :department
  has_many :sections
  
  def fullname
    "#{last} #{given} #{middle}"
  end
end
