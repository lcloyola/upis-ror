class RemoveEmailFromFaculties < ActiveRecord::Migration
  def change
    remove_column :faculties, :email
  end
end

