class Gwa < ActiveRecord::Base
  belongs_to :student
  belongs_to :schoolyear

  def self.search(schoolyear, batch, mode)
  	return Gwa.joins(:student).where('students.id' => batch.id, 'schoolyear_id' => schoolyear.id, 'gwa_type' => mode)
  end
end