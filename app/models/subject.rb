class Subject < ActiveRecord::Base
  belongs_to :department
  has_many :courses
  
  def details
    "#{name} ( #{units} )"
  end
end
