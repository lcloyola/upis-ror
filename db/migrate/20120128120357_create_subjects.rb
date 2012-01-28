class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.references :department
      t.integer :units
      t.integer :year

      t.timestamps
    end
    add_index :subjects, :department_id
  end
end
