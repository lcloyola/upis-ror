class Removal < ActiveRecord::Base
  belongs_to :course
  belongs_to :student

  def value
    return "(3.0)" if self.pass
    return "(5.0)"
  end
end

