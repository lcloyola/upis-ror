class AddBirthdayAndContactToFaculty < ActiveRecord::Migration
  def change
    add_column :faculties, :birthday, :date
    add_column :faculties, :landline, :string
  end
end
