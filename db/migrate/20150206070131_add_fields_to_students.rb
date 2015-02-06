class AddFieldsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :elem_completed_in, :string
    add_column :students, :elem_completed_on, :date
    add_column :students, :citizenship, :date
  end
end
