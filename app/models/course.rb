class Course < ActiveRecord::Base
  belongs_to :subject
  belongs_to :faculty
  belongs_to :schoolyear
  belongs_to :section
end
