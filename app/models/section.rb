class Section < ActiveRecord::Base
  validates_inclusion_of :year, :in => -3..12, :message => "can only be from -2 and 12."
  validates_numericality_of :year, :only_integer => true, :message => "can only be whole number."
  validates_uniqueness_of :name, :scope => [:schoolyear_id]
  validates_presence_of :schoolyear_id, :faculty_id, :batch_id, :year, :name

  belongs_to :schoolyear
  belongs_to :faculty
  belongs_to :batch
  has_many :courses
  has_many :members, :foreign_key => :section_id, :dependent => :destroy
  has_many :students, :through => :members, :source => :student, :dependent => :destroy

  def fullname
    return "#{self.year} - #{self.name}"
  end
  def year_type
    return "Extra Curricular" if self.year == -3
    return "Work Program" if self.year == -2
    return "Elective" if self.year == -1
    return "Kinder" if self.year == 0
    return year
  end
end

