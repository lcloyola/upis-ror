class Section < ActiveRecord::Base
  belongs_to :schoolyear
  belongs_to :faculty
  belongs_to :batch
end
