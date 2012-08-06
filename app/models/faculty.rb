class Faculty < ActiveRecord::Base
  belongs_to :department
  has_many :sections
  has_many :courses
  has_one :user
  validates_presence_of :department_id, :last, :given

  def fullname
    "#{last} #{given} #{middle}"
  end
end

