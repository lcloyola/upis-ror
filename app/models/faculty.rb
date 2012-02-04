class Faculty < ActiveRecord::Base
  belongs_to :department
  has_many :sections
end
