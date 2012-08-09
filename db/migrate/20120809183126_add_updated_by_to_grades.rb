class AddUpdatedByToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :updated_by, :integer
    add_column :removals, :updated_by, :integer
  end
end

