class Faculty < ActiveRecord::Base
  belongs_to :department
  has_many :sections
  has_many :courses
  belongs_to :user
  validates_presence_of :department_id, :last, :given

  def fullname
    "#{last} #{given} #{middle}"
  end
  def email
    if self.user.present?
      return self.user.email
    end
    return ""
  end
end

