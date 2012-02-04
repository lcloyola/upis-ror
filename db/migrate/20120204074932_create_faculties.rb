class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :last
      t.string :given
      t.string :middle
      t.references :department
      t.date :appointment
      t.string :email
      t.string :mobile

      t.timestamps
    end
    add_index :faculties, :department_id
  end
end
