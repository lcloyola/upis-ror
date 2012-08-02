class AddSexToStudents < ActiveRecord::Migration
  def change
    add_column :students, :sex, :string, :default => "M"
  end
end

